sudo apt update
sudo apt upgrade
sudo apt install openjdk-11-jdk -y
wget https://downloads.apache.org/jmeter/binaries/apache-jmeter-5.6.3.tgz
tar -xvzf apache-jmeter-5.6.3.tgz
mv apache-jmeter-5.6.3 apache-jmeter
export JMETER_HOME=/home/ubuntu/apache-jmeter
export PATH=$JMETER_HOME/bin:$PATH
sudo vi ~/.bashrc 
source ~/.bashrc 
scp -i "minikube.pem" /Users/taiwo/Documents/Post.jmx ubuntu@ec2-54-211-167-201.compute-1.amazonaws.com:/home/ubuntu/
jmeter -n -t /home/ubuntu/Post.jmx -l /home/ubuntu/results.jtl
ls -lah
cat results.jtl 
tail -f /home/ubuntu/results.jtl
scp -i /path/to/your-key.pem ubuntu@ec2-54-211-167-201.compute-1.amazonaws.com:/home/ubuntu/results.jtl /path/to/local/directory###
ls -lah
pwd
jmeter -g /home/ubuntu/results.jtl -o /home/ubuntu/html-report
mkdir html-report
jmeter -g /home/ubuntu/results.jtl -o /home/ubuntu/html-report
ls -lah
cd html-report/
ls
cd 
jmeter -g /home/ubuntu/results.jtl -o "/home/ubuntu/html-report"
jmeter --version
ls -lah
cd apache-jmeter/
cd bin/
ls
ls -la
vi jmeter
cd
jmeter -g /home/ubuntu/results.jtl -o /home/ubuntu/html-report -LDEBUG
ls
ps 
nohup jmeter -n -t /home/ubuntu/Post.jmx -l /home/ubuntu/results.jtl > /tmp/"output_log_file_name" 2>&1 &
history
cd /tmp/
ls
ls -la
cat output_log_file_name 
ls -la
cd
ls
cat Post.jmx 
cat results.jtl
ls -la
history
nohup jmeter -n -t request.jmx -l results.jtl > jmeter.log 2>&1 && notify-send "JMeter Test" "JMeter test has completed" & 
sudo apt install libnotify-bin
nohup jmeter -n -t request.jmx -l results.jtl > jmeter.log 2>&1 && notify-send "JMeter Test" "JMeter test has completed" &
systemctl status libnotify-bin
ps -aux | grep libnotify-bin
sudo systemctl status libnotify-bin
which libnotify-bin
cd /etc/systemd/system/
ls | grep lib
ls 
sudo apt-get --reinstall install libnotify-bin notify-osd
nohup jmeter -n -t request.jmx -l results.jtl > jmeter.log 2>&1 && notify-send "JMeter Test" "JMeter test has completed" &
nohup jmeter -n -t request.jmx -l results.jtl > jmeter.log 2>&1 &
sudo nohup jmeter -n -t request.jmx -l results.jtl > jmeter.log 2>&1 &
sudo apt-get purge libnotify-bin notify-osd
nohup jmeter -n -t request.jmx -l results.jtl > jmeter.log 2>&1 &
history
nohup jmeter -n -t request.jmx -l results.jtl > jmeter.log 2>&1 &
cd
nohup jmeter -n -t request.jmx -l results.jtl > jmeter.log 2>&1 &
echo $JMETER_PID
nohup jmeter -n -t request.jmx -l results.jtl > jmeter.log 2>&1 &
echo $JMETER_PID
nohup jmeter -n -t request.jmx -l results.jtl > jmeter.log 2>&1 &
pgrep -f "jmeter -n -t request.jmx -l results.jtl"
nohup jmeter -n -t request.jmx -l results.jtl > jmeter.log 2>&1 &
ps -eo pid
pstree
ps -ef
ps -ef 
pwd
jmeter --version
nohup jmeter -n -t request.jmx -l results.jtl > /tmp/"output_log_file_name" 2>&1 &
ps -aux | grep jmeter
nohup jmeter -n -t request.jmx -l results.jtl > jmeter.log 2>&1 &
ps
jmeter -g results.jtl -e -o html/
jmeter -g results.jtl -o html-report/
pwd
nohup jmeter -n -t request.jmx -l results.jtl > jmeter.log 2>&1 &
jmeter -g results.jtl -o html-report/
history
