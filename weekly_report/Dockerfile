FROM node:lts-hydrogen
MAINTAINER duanshuaixing "duanshuaixing@gmail.com"
WORKDIR /opt
ADD ./weekly_report.sh /opt/
RUN /opt/weekly_report.sh
EXPOSE 3000
EXPOSE ${api_key}
CMD sed 's/OPENAI_API_KEY=/OPENAI_API_KEY='$api_key'/' /opt/weekly_report/.env  && cd /opt/weekly_report && npm run dev
