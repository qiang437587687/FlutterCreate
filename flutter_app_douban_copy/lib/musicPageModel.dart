import 'package:html/parser.dart';
import 'package:html/dom.dart';
import 'package:flutter_app_douban_copy/utils/Logger.dart';


//解析html ------> 😂
class MusicPageModel {

  final List<MusicBanner> bannerList;
  final List<MusicTitle<MusicFashionItem>> fashionList;
  final MusicTitle<MusicEditItem> editList;
  final MusicTitle<Music250Item> m250List;

  MusicPageModel(this.bannerList, this.fashionList, this.editList, this.m250List);

  factory MusicPageModel.formHtml(String html) {
    Document doc = parse(html);
//    Logger("doc", doc);
    var body = doc.body;
    Logger("MusicPageModel body",body);
    List<MusicBanner> bannerList = [];
    var slickList = body.getElementsByClassName('top-banner');
    if (slickList.length > 0) {
      Element firstSlick = slickList.first;
      List<Element> aBannerList = firstSlick.getElementsByTagName("a");
      aBannerList.forEach((e) {
        String address = e.attributes['href'];
        String imageAddress;
        var imgList = e.getElementsByTagName("img");
        if (imgList.length > 0) {
          var imgItem = imgList.first;
          imageAddress = imgItem.attributes['src'];
        }
        bannerList.add(MusicBanner(address, imageAddress));

      });
      Logger("slickList in local",bannerList);
    }


    //解析流行音乐
    List<MusicTitle<MusicFashionItem>> fashionList = [];

    var popular = body.getElementsByClassName('popular-artists');
    if (popular.length > 0) {
      var ul = popular.first.getElementsByTagName('ul');
      if (ul.length > 0) {
        var liList = ul.first.getElementsByTagName('li');
        liList.forEach((e) {
          List<MusicFashionItem> fashionItemList = [];
          String title = e.text;
          String classTag = e.attributes['class'].replaceAll('-tab', '');
          var classTagEl = popular.first.getElementsByClassName(classTag).first;
          classTagEl.getElementsByClassName('artist-item').forEach((c) {
            var afirst = c.getElementsByTagName('a').first;
            String address = 'https://music.douban.com${afirst.attributes['href']}';
            String style = afirst
                .getElementsByClassName('artist-photo-img')
                .first
                .attributes['style'];
            String imageAddress = style.substring(
                style.indexOf('\'') + 1, style.lastIndexOf('\''));
            String name = c.getElementsByTagName('a').last.text;
            String type = c.getElementsByTagName('p').last.text;
            String hoverLay = '';
            c
                .getElementsByClassName('hoverlay')
                .first
                .getElementsByTagName('p')
                .forEach((e) {
              hoverLay += "${e.text}\n";
            });
            if (hoverLay.length > 0) {
              hoverLay.substring(0, hoverLay.length - 1);
            }
            fashionItemList.add(
                MusicFashionItem(imageAddress, address, name, type, hoverLay));
          });
          fashionList.add(new MusicTitle(title, fashionItemList));
        });
      }
    }

    //编辑推荐
    var editorFeatured = body.getElementsByClassName('editor-featured');
    List<MusicEditItem> editItemList = [];
    if (editorFeatured.length > 0) {
      var slick = editorFeatured.first.getElementsByClassName('feature-item');
      slick.forEach((e) {
        var aMap = e.getElementsByTagName('a').first.attributes;
        String imageAddress = aMap['style'];
        imageAddress = imageAddress.substring(
            imageAddress.indexOf('(') + 1, imageAddress.lastIndexOf(')'));
        String address = aMap['href'];
        var hoverlay = e.getElementsByClassName('hoverlay').first;
        String hoverLaytext = '';
        hoverlay.getElementsByTagName('p').forEach((e) {
          hoverLaytext += "${e.text}\n";
        });
        if (hoverLaytext.length > 0) {
          hoverLaytext.substring(0, hoverLaytext.length - 1);
        }
        String name = e.getElementsByTagName('h3').first.text;
        String des = e.getElementsByTagName('h4').first.text;
        String summery = e.getElementsByTagName('p').last.text;
        editItemList.add(MusicEditItem(
            imageAddress, hoverLaytext, address, name, des, summery));
      });
    }

    MusicTitle<MusicEditItem> editItem=MusicTitle<MusicEditItem>('编辑推荐', editItemList);

    //最新
    List<Music250Item> music250List = [];

    var recInfo = body.getElementsByClassName('rec-info');
    var recInfoa = recInfo.first.getElementsByTagName('dl');
    recInfoa.forEach((e) {
      var alast = e.getElementsByTagName('a').last;
      String href = alast.attributes['href'];
      String title = alast.text;
      String src = e.getElementsByTagName('img').first.attributes['src'];
      music250List.add(Music250Item(title, href, src));
    });
    MusicTitle<Music250Item> m250List = MusicTitle('豆瓣250', music250List);
    return MusicPageModel(bannerList, fashionList, editItem, m250List);

  }

}

class MusicTitle<T> {
  final String title;
  final List<T> itemList;

  MusicTitle(this.title, this.itemList);
}

class MusicBanner {
  final String address;
  final String imageAddress;

  MusicBanner(this.address, this.imageAddress);
}

//流行音乐人
class MusicFashionItem {
  final String address;

  final String imageAddress;
  final String name;
  final String type;
  final String hoverLay;

  MusicFashionItem(
      this.imageAddress, this.address, this.name, this.type, this.hoverLay);
}

//编辑推荐
class MusicEditItem {
  final String imageAddress; //图片地址
  final String hoverLay; //播放列表
  final String address; //播放地址
  final String name; //音乐人姓名
  final String des; //编辑推荐
  final String summery;//介绍

  MusicEditItem(this.imageAddress, this.hoverLay, this.address, this.name,
      this.des, this.summery); //介绍
}

//新碟榜
class Music250Item {
  final String title; //歌曲名
  final String address;
  final String imageAddress;

  Music250Item(this.title, this.address, this.imageAddress); //地址
}
