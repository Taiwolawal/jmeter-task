#!/bin/bash

# Path to CSV and JMX file 
get_csv="/home/ubuntu/get.csv"
post_csv="/home/ubuntu/post.csv"
jmx_file="/home/ubuntu/request.jmx" 

# Get the current time in a specific format
current_time=$(date +"%Y%m%d%H%M%S")

# Define the result directory
result_dir="/home/ubuntu/result"

# Create the JTL file name with the current time
jtl_file_name="result-${current_time}.jtl"

# Define the full path to the result file
result_file="${result_dir}/${jtl_file_name}"

touch $jtl_file_name

# Function to update XML values using sed
update_xml_value() {
    local search="$1"
    local replace="$2"
    local file="$3"
    sed -i "" "s#${search}#${replace}#g" "$file"

    #nohup jmeter -n -t request.jmx -l results.jtl > /tmp/"output_log_file_name" 2>&1 &
}

# Ask for the type of test in a loop until valid input is provided
while true; do
    read -p "What type of test (get or post)? " test_type
    if [[ "$test_type" == "get" || "$test_type" == "post" ]]; then
        break
    else
        echo "Invalid test type. Please enter 'get' or 'post'."
    fi
done

# Set the appropriate CSV file path
csv_file=""
if [[ "$test_type" == "get" ]]; then
    csv_file="$get_csv"
else
    csv_file="$post_csv"
fi

# Ask for the number of threads
while true; do
    read -p "Number of Threads (users): " num_threads
    if [[ "$num_threads" =~ ^[0-9]+$ ]] && [[ "$num_threads" -gt 1 ]]; then
        update_xml_value "<intProp name=\"ThreadGroup.num_threads\">.*</intProp>" "<intProp name=\"ThreadGroup.num_threads\">${num_threads}</intProp>" "$jmx_file"
        break
    else
        echo "Invalid number of threads. Please enter a number greater than 1."
    fi
done


# Ask for the ramp-up period
while true; do
    read -p "Ramp-up period (seconds): " ramp_up
    if [[ "$ramp_up" =~ ^[0-9]+$ ]] && [[ "$ramp_up" -gt 1 ]]; then
        update_xml_value "<intProp name=\"ThreadGroup.ramp_time\">.*</intProp>" "<intProp name=\"ThreadGroup.ramp_time\">${ramp_up}</intProp>" "$jmx_file"
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
        update_xml_value "<boolProp name=\"ThreadGroup.same_user_on_next_iteration\">.*</boolProp>" "<boolProp name=\"ThreadGroup.same_user_on_next_iteration\">${same_user_bool}</boolProp>" "$jmx_file"
        break
    elif [[ "$same_user" == "n" || "$same_user" == "no" ]]; then
        same_user_bool="false"
        update_xml_value "<boolProp name=\"ThreadGroup.same_user_on_next_iteration\">.*</boolProp>" "<boolProp name=\"ThreadGroup.same_user_on_next_iteration\">${same_user_bool}</boolProp>" "$jmx_file"
        break
    else
        echo "Invalid input. Please enter 'y' or 'n'."
    fi
done

# Ask for the duration
while true; do
    read -p "Duration (seconds): " duration
    if [[ "$duration" =~ ^[0-9]+$ ]] && [[ "$duration" -gt 1 ]]; then
        update_xml_value "<longProp name=\"ThreadGroup.duration\">.*</longProp>" "<longProp name=\"ThreadGroup.duration\">${duration}</longProp>" "$jmx_file"
        break
    else
        echo "Invalid duration. Please enter a number greater than 1."
    fi
done



# The two (2) functions below need refactoring
# Update ResultCollector configuration with result_file path
update_xml_value "<ResultCollector guiclass=\"SummaryReport\" testclass=\"ResultCollector\" testname=\"Summary Report\" enabled=\"true\">\s*<stringProp name=\"filename\">.*</stringProp>" "<stringProp name=\"filename\">${result_file}</stringProp>" "$jmx_file"

# Update CSVDataSet configuration with csv_file path
update_xml_value "<CSVDataSet guiclass=\"TestBeanGUI\" testclass=\"CSVDataSet\" testname=\"CSV Request Data\" enabled=\"true\">\s*<stringProp name=\"filename\">.*</stringProp>" "<stringProp name=\"filename\">${csv_file}</stringProp>" "$jmx_file"


echo "JMX file has been updated successfully."




# Check if JMeter test completed successfully (Pending)
# if grep -q "StandardJMeterEngine: Notifying test listeners of end of test" "$LOG_FILE"; then
#     echo "JMeter test completed successfully."
# else
#     echo "JMeter test did not complete successfully. Check the log file for details."
#     exit 1
# fi




