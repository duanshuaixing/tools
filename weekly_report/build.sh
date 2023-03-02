#RUN  docker run -itd --restart=always --name=weekly_report  -e api_key=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 -p8888:3000 weekly_report:node-lts-hydrogen

docker build -t weekly_report:node-lts-hydrogen ./

