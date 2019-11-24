# Rails Video cutting API

####Dependencies
###### 1. ffmpeg
###### 2. delayed_job

## Install

### Clone repository
```
git clone https://github.com/npolevara/video_api
```

### Install gems
```
cd video_api
```

```
bundle install
```
##### add delayed job indexes
```
script/rails runner 'Delayed::Backend::Mongoid::Job.create_indexes
```
### install ffmpeg
```
sudo apt update
sudo apt-get install ffmpeg
```
### Setup ENV
```
ROOT_URL=http://127.0.0.1:3000
```
### Run specs
```
rspec
```

### Run server
```
rails s
```
### Run delayed_job queue
```
bin/delayed_job --queue=cropping start
```

## API documentation

### Sign In User
###### generate new user with token
```
localhost:3000/api/v1/signin
```
``
{
    "id": USER_ID,
    "authentication_token": TOKEN
}
``
###### if send localhost:3000/api/v1/signin?authentication_token=TOKEN
###### server returns user TOKEN only

### GET User video list
```
localhost:3000/api/v1/videos?authentication_token=TOKEN
```
````
{
    "id": USER_ID,
    "video_list": []
}
````
###### new user has no videos

### POST new video
```
localhost:3000/api/v1/upload?authentication_token=TOKEN
```
###### body = form-data
###### authentication_token = TOKEN
###### name = 'video name'
###### source = file 'local file path'
###### cut_from = 10 'start cut position in seconds'
###### cut_length = 200 'length cut position in seconds'

````
{
    "name": "video_name"
}
````
### GET User video list after upload
```
localhost:3000/api/v1/videos?authentication_token=TOKEN
```
###### return list of uploader and croppd file
````
{
    "id": USER_ID,
    "video_list": [
        [
            "video_name",
            "00:10:03.59",
            "scheduled",
            "http://127.0.0.1:3000/api/v1/download?authentication_token=TOKEN&name=video_name&id=USER_ID"
        ]
    ]
}
````
###### after ffmpeg finish task in background
````
{
    "id": USER_ID,
    "video_list": [
        [
            "video_name",
            "00:10:03.59",
            "done",
            "http://127.0.0.1:3000/api/v1/download?authentication_token=TOKEN&name=video_name&id=USER_ID"
        ],
        [
            "video_name_cropped",
            "00:08:20.04",
            "cropped",
            "http://127.0.0.1:3000/api/v1/download?authentication_token=TOKEN&name=video_name_cropped&id=USER_ID"
        ]
    ]
}
````
### POST Restart failed video
###### restart video with status failed
`````
localhost:3000/api/v1/restart?authentication_token=TOKEN&name=video_name&cut_from=10&cut_length=25
`````
###### authentication_token = TOKEN
###### name = 'video_name'
###### cut_from = 10 'start cut position in seconds'
###### cut_length = 200 'length cut position in seconds'