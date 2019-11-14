# 9Hits-AutoInstall

![](https://pbs.twimg.com/profile_images/801085299988123649/RyfqK0ww_200x200.jpg)

![](https://img.shields.io/github/stars/pandao/editor.md.svg) ![](https://img.shields.io/github/forks/pandao/editor.md.svg) ![](https://img.shields.io/github/tag/pandao/editor.md.svg) ![](https://img.shields.io/github/release/pandao/editor.md.svg) ![](https://img.shields.io/github/issues/pandao/editor.md.svg) ![](https://img.shields.io/bower/v/editor.md.svg)

### Features

- Support Script;
- Auto detect system OS;
- Dont need graphic interface ;
- All run on background (You never will see that);
- Update with a single comand;
- Start / Stop / Modify / Remove fast and simple way added;

## **HOW TO INSTALL**

**You have 3 types of install**

📌 **Simple version, you dont need do nothing, you will get only 1 sessions (System)**

Example command:

yum -y update || apt update && yum -y install git whiptail || apt install -y git whiptail && cd /root && git clone https://github.com/MauroS5/9Hits-AutoInstall.git && chmod -R 777 9Hits-AutoInstall && 9Hits-AutoInstall/install.sh "0" "d2lpb0dc88554721ca9c3a6a1ef710b3" && rm install.sh

 📌 **Advanced version, code will ask you some questions to make it more custom**

Example command:

yum -y update || apt update && yum -y install git whiptail || apt install -y git whiptail && cd /root && git clone https://github.com/MauroS5/9Hits-AutoInstall.git && chmod -R 777 9Hits-AutoInstall && 9Hits-AutoInstall/install.sh "1" "d2lpb0dc88554721ca9c3a6a1ef710b3" && rm install.sh

📌 **Script version, all in one code by arguments ( You need set it on this order: "Version (0,1,2)" "Token" "Number of sessions" "MaxCpu ussage (Dont use %, just number) "Restart time (Read more down :fa-arrow-circle-down:)"**

Example command:

yum -y update || apt update && yum -y install git whiptail || apt install -y git whiptail && cd /root && git clone https://github.com/MauroS5/9Hits-AutoInstall.git && chmod -R 777 9Hits-AutoInstall && 9Hits-AutoInstall/install.sh "2" "d2lpb0dc88554721ca9c3a6a1ef710b3" "15" "10" "1" && rm install.sh

Restart time have 6 levels:

1 "Every 30 minutes"

2 "Every 1 hour"

3 "Every 2 hours"

4 "Every 6 houts" 

5 "Every 12 hours"

6 "Every day"

For more custom restart you will need modify crontab file as you want.

