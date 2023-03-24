# ros2_humble_docker
ros 2 humbleが使えるdockerコンテナを作成するためのDockerfileです。  

## 1. dockerのインストール  
公式のスクリプトを利用します。
```
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
```

## 2. docker-compose-pluginの追加  
公式のスクリプトを利用してdockerをインストールした場合、docker-compose-pluginが自動で追加されるようです。  
追加されていなかった場合、下記のコマンドを使用して追加してください。  
```
sudo apt install docker-compose-plugin
```

## 3. リポジトリのクローン
```
git clone https://github.com/CIT-Autonomous-Robot-Lab/ros2_humble_docker.git
```

## 4. docker-compose.ymlの書き換え
docker-compose.ymlを使用中の環境に合わせて書き換えてください。  
  
*USER_NAME=ローカルユーザ名*  
*GROUP_NAME=ローカルユーザのグループ名*  
*UID=ローカルユーザのID*  
*GID＝ローカルユーザのグループID*  
*/home/aoki/ros2_humble_ws=ホストPCに用意したros 2ワークスペースの絶対パス*  
  
USER情報は以下のコマンドで確認できます。
```
whoami
```
ユーザー名が出力されます。  
`aoki`  
  
ユーザーid、グループ名、グループidを表示します。  
```
id aoki
```
出力  
`uid=1000(aoki) gid=1000(aoki) groups=1000(aoki)`  
uid=ユーザーid　gid=グループid　groups=所属しているグループ

## 5. 実行
イメージを作成します。
```
cd ros2_humble_docker
docker-compose build
```
コンテナを立ち上げます。
```
docker-compose up -d
```
以下のコマンドを実行。
```
xhost +
```
コンテナに入ります。
```
docker-compose exec ros2 /bin/bash
```
コンテナ内でrvizを起動し、画面が表示されれば完了です。
```
source /opt/ros/humble/setup.sh
rviz2
```
コンテナから出てコンテナを停止させます。
```
exit
docker-compose down
xhost -
```
