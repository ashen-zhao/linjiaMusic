//
//  API.h
//  WeiYueMusic
//
//  Created by ashen on 16/4/19.
//  Copyright © 2016年 Ashen. All rights reserved.
//

#ifndef API_h
#define API_h


//本项目纯属技术分享，切勿用户商业目的，否则后果自负
//由于接口涉及到法律风险，我这里将接口去除，会导致项目无法运行；
//如需请自行抓取（或者发邮件到zhaoashen@gmail.com索取,邮件主题或内容中，请包含API三个字母，则接口内容会自动回复到你的邮箱(QQ邮箱可能会进入垃圾邮箱)，否则需要等待24小时左右。）

#define kMusicHotViewController @"frontpage/frontpage"

#define kMusicListControllerWeekMusic @"channel/ranklist/%@/songs?page=1"

#define kMusicListControllerSingerMusic @"song/singer/%@/songs?page=1&size=50"

#define kMusicListControllerSongType @"channel/channel/%@/songs?size=50&page=1"

#define kMusicListControllerOther @"songlists/%@"


#define kMusicWeekController @"/ttpod?a=getnewttpod&id=281"


#define kNewCDController @"recomm/new_albums?page=1&size=30"

#define kOpenSearchController @"/sug/billboard"

#define kSearchController @"/s/song_with_out"

#define kSingerController @"/ttpod?a=getnewttpod&id=%@&size=1000&page=1"

#define kSingerTypeController @"/ttpod?a=getnewttpod&id=46"

#define kSongTypeController @"/channellist?image_type=240_200"

#endif /* API_h */
