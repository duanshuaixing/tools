#!/bin/bash
install(){
   cd /opt/
   git clone https://github.com/guaguaguaxia/weekly_report.git
   mv /opt/weekly_report/.env.example /opt/weekly_report/.env
   cd /opt/weekly_report/
   npm install
}

install
