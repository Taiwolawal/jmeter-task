#!/bin/bash

# Path to CSV and JMX file 
get_csv="/home/ubuntu/get.csv"
post_csv="/home/ubuntu/post.csv"
jmx_file="/home/ubuntu/request.jmx" 

# Define the HTML directory
html_dir="/home/ubuntu/html"

# Get the current time in a specific format
current_time=$(date +"%d-%m-%YT%H:%M:%S")

# Define the results directory
result_dir="/home/ubuntu/results"

# Create the JTL file name with the current time
jtl_file_name="result-${current_time}.jtl"

# Define the full path to the result file
result_file="${result_dir}/${jtl_file_name}"

# Log file path
jmeter_log_file="/home/ubuntu/jmeter.log"
html_log_file="/home/ubuntu/html.log"
s3_log_file="/home/ubuntu/s3.log"

# Line to update CSV path
csv_line=116

# Ask for the type of test in a loop until valid input is provided
while true; do
    read -p "What type of test (get or post)? " test_type
    if [[ "$test_type" == "get" || "$test_type" == "post" ]]; then
        break
    else
        echo "Invalid test type. Please enter 'get' or 'post'."
    fi
done

# HTML directory name with test type
html_file="${test_type}-html-${current_time}"

# Full path to the new HTML directory
full_html_path="${html_dir}/${html_file}"

# Create the subdirectory inside html_dir
mkdir -p "$full_html_path"

# Set the appropriate CSV file path
csv_file_path=""
if [[ "$test_type" == "get" ]]; then
    csv_file_path="$get_csv"
else
    csv_file_path="$post_csv"
fi

# Function to update csv path in the csv line
update_csv_path() {
    local line_number="$1"
    local replace="$2"
    local file="$3"
    local indent="          "

   # Detect OS and use appropriate sed -i option
    if [[ "$OSTYPE" == "darwin"* ]]; then
        sed -i "" "${line_number}s#.*#${indent}${replace}#" "$file"
    else
        sed -i "${line_number}s#.*#${indent}${replace}#" "$file"
    fi
}

update_csv_path "$csv_line" "<stringProp name=\"filename\">${csv_file_path}</stringProp>" "$jmx_file"

# Function to update XML values using sed
update_jmx_value() {
    local search="$1"
    local replace="$2"
    local file="$3"

    # Detect OS and use appropriate sed -i option
    if [[ "$OSTYPE" == "darwin"* ]]; then
        sed -i "" "s#${search}#${replace}#g" "$file"
    else
        sed -i "s#${search}#${replace}#g" "$file"
    fi

}

# Ask for the number of threads
while true; do
    read -p "Number of Threads (users): " num_threads
    if [[ "$num_threads" =~ ^[0-9]+$ ]] && [[ "$num_threads" -gt 1 ]]; then
        update_jmx_value "<intProp name=\"ThreadGroup.num_threads\">.*</intProp>" \
                         "<intProp name=\"ThreadGroup.num_threads\">${num_threads}</intProp>" \
                         "$jmx_file"
        break
    else
        echo "Invalid number of threads. Please enter a number greater than 1."
    fi
done


# Ask for the ramp-up period
while true; do
    read -p "Ramp-up period (seconds): " ramp_up
    if [[ "$ramp_up" =~ ^[0-9]+$ ]] && [[ "$ramp_up" -gt 1 ]]; then
        update_jmx_value "<intProp name=\"ThreadGroup.ramp_time\">.*</intProp>" \
                         "<intProp name=\"ThreadGroup.ramp_time\">${ramp_up}</intProp>" \
                         "$jmx_file"
        break
    else
        echo "Invalid ramp-up period. Please enter a number greater than 1."
    fi
done

# Ask for the same user on each iteration
while true; do
    read -p "Same user on each iteration (y/n): " same_user
    if [[ "$same_user" == "y" || "$same_user" == "yes" ]]; then
        same_user_bool="true"
        update_jmx_value "<boolProp name=\"ThreadGroup.same_user_on_next_iteration\">.*</boolProp>" \
                         "<boolProp name=\"ThreadGroup.same_user_on_next_iteration\">${same_user_bool}</boolProp>" \
                         "$jmx_file"
        break
    elif [[ "$same_user" == "n" || "$same_user" == "no" ]]; then
        same_user_bool="false"
        update_jmx_value "<boolProp name=\"ThreadGroup.same_user_on_next_iteration\">.*</boolProp>" \
                         "<boolProp name=\"ThreadGroup.same_user_on_next_iteration\">${same_user_bool}</boolProp>" \
                         "$jmx_file"
        break
    else
        echo "Invalid input. Please enter 'y' or 'n'."
    fi
done

# Ask for the duration
while true; do
    read -p "Duration (seconds): " duration
    if [[ "$duration" =~ ^[0-9]+$ ]] && [[ "$duration" -gt 1 ]]; then
        update_jmx_value "<longProp name=\"ThreadGroup.duration\">.*</longProp>" \
                         "<longProp name=\"ThreadGroup.duration\">${duration}</longProp>" \
                         "$jmx_file"
        break
    else
        echo "Invalid duration. Please enter a number greater than 1."
    fi
done

echo "JMX file has been updated successfully."

# Run JMeter test in the background
jmeter -n -t "$jmx_file" -l "$result_file" > "$jmeter_log_file" 2>&1 &
JMETER_PID=$!
echo "Running Jmeter test in the background with PID $JMETER_PID"

# Check the status of the JMeter process every 10 seconds
while kill -0 $JMETER_PID 2> /dev/null; do
  sleep 10
  echo "Jmeter test is still running"
done

# Wait for the JMeter process to finish
wait $JMETER_PID
echo "JMeter test has finished"

# Generate the HTML report
jmeter -g "$result_file" -o "$full_html_path" > "$html_log_file" 2>&1
echo "Generating HTML report"

# Uploading HTML report to S3
aws s3 cp $full_html_path s3://zettaday-jmeter-result/$html_file --recursive  > "$s3_log_file" 2>&1 &
S3_PID=$!
echo "Uploading HTML report to S3 in the background with PID $S3_PID"

# Wait for the JMeter process to finish
wait $S3_PID
echo "HTML report uploaded completely to S3"

