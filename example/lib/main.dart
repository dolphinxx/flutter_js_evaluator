import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

import 'package:flutter_js_evaluator/flutter_js_evaluator.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  String lastAssignSource = 'a=1';
  String dateSource = '''
  new Date();
  ''';
  String intSource = 'var a = 1;';
  String doubleSource = 'var a = 3.141592658579154847327950288';
  String booleanSource = 'var a = true';
  String undefinedSource = 'var a = undefined';
  String nullSource = 'var a = null;';
  String arraySource = '[1, 2, "hello"]';
  String objectSource = 'var a = {"a":1, "b": 2, "c": {"a": "a", "b": [1], "c": new Date()}}';
  String md5Source = 'md5("123")';
  String btoaSource = 'btoa("123")';
  String atobSource = 'atob("MTIz")';
  String fnSource = '''
function add(x, y) {
  return x + y;
}
add(1, 2);
''';
  String largeSource = r'''
var _0x4415=['wrQzJjzDiQ==','CFPCnjAm','wogDw5RgaA==','wqo/QBLCojLCvw==','OioI','NEFcBGJkVg==','w53DjwbCvw==','QjDDvSZywoPDiA==','w79Xw4nDqB4=','wrAFOyfDh0hY','eBMVCw==','Mzcdw7XChQ==','cmVJw5NjBcKA','w4LCpMOWw6vDtRJWGDw=','eV/DisOJwqUZBA==','w6Ybw5kueQ==','PMOAAcOONl/CgcOCwqTDtGMSXwQ0wqrCj8O9wo5tQcKhw5HCu+evpsKjwq/Dl+eojOS8q+S5v+mFrkBQOCRDw7BPw4fDi2tDwrTCjsKcwrt2wpPClnJ4QMOnw5XDlQg4RgQtw6rCvMO6woXCnhx95p6O5b6U5bGk55uP55yU5rCm5rG/772V5ZO35ae+5oaB6KaJ5biS6Kyk5rOi6Zaq6aCQ55mj44Ozwr3Dhg4Bw7bCiFvCu18RJsODw6dIw67DtGPCsljCgnANw5IsC8OCwrV4VCHDgcKRw5kUw5PDueiCkuS5oeiFkeW1oOS7uuWWjui9tOawh++8kuWlquaes+iXg+iWseecgueaveihhui9iuWBo+S7hu++geS7rOWGleaUnuaLkeepkOmfmOWOnOS6meS4i+i8guOBuE9CLX4fw5xOIX7DvsKAw4HCk8OqfB7DlHbDi3bCsFjDsixiWcO0w5kJw5Vkwr/DqDzCrEDnqobpnpTljoPlgqvnnLrnn7HnnYDlkK7lpKnvvIrlvJnmgbPkvbrlsZHlrZDls5znirzlkovvvonovKLml7vmiK7mi6nvvYDkv5bnuL/mirrnr6fnn7rvva/DisKGwpkFwq/Dt8KKL31nw57CrcKYB1HDkXExw4TCksOpw6lTUMKMw70uNzLCskDCsMOew5Ftw7nolbnolYPmi6Toj7bkurnmn5rkuZblkLbvv4rlpajltITnuqjom6PlvpvlvoPlhJjkub7nq6XkuIvkvr7ku73vvo/lkIXlpaHmiqPnn6rlpqzvvIrlpI/miLzog6Hli7DlvbjnmIXnq5TkvaDjgajCtMKjw50gMRM5bm50w6vClMKLE0nDswPCo8OndQNPwqzCrEQyw67Ck8Kyw4TCjVjDtcOWHcOH4oO/5L+U5oWZ6KW15oCN5Lq55qGi5Lqu77yt4oKWVw7DoMK0w5PCri1AOwfDi27DqcK5wrlTUXLDu1PCjMKow5/Cn8Kaw7LDsBHDgQ17SFXCujLCpuWQn+Wnu+WGheWIvueYkumUkuiUoOiUuuOAnsOTwp7Dv8KRwq92Wnkrw7zCqMKGGQTCkxtyw4gdX0wJS8OYLHsxGsOfF8KIABTDgMKlwqzoloPolKvmkpPku5Dmk4LlppfvvLfpgZ7vvLjig5fnj4vln7/ovKjmsLLku7rkuIzmhZXopY/vvarov43mmYrog5vmoYHlrJHjg6bigLE5QG/CgFjCkcOswq/DhcOmwrrDqnvCn8OqVXVmUsOpwroRSsOcwr3CscKHPHl/WcKzYHPCqcKw4oCP5LyO6Ly26I+A5ae35Li86IKW55WL5pSz776a4oOlw7XDusOoDT8zKjUdCMOQwolrAkhoXGFrXVfCjsOCL8Otw6LClsO2w5czw7PDr8O7I8O3w5Xlkbvlp5TplZLnqpPpnI7ljL/jg50WBMOjwrjDtMKDQSPCpB8jw5fCq2k8XCbDlsOkCcOsIkvDt8Kfw7nCvCl2w6HCnBTCmELCh8Om4oKS5p+95oSr5YyD5bOb5pWT5Lux5bO25oq65qyH6Kea5LiE772K5L6Q5pWA5b6U5ZGF5ZGi5aa45Ye055eR772K5omG5Lm55paw6amp5L+y55mZ44KR4oGJw6rDkCAjSMKTw6xqDMO2O1vDocOcMcKIIcOpRcKOG2NPamUNwpPDi8KDwoPDocO4w7cZIzfnqI3pn43lj5fnjZ/lna/kuanlpoXkup3vvYjngL3lpZzlka7ohrXnmYrlrbTlkYflp7HpgZ7jgqnCujPDucKDwpbDssKcMMKGw5DCh3Z1HFPDuizCnTBAG8KCwoN7w7N3Nnx8wrnCgTB0TR7DkOWQkuWknOawhuiunuS7geS6ge+9huS6u+S5tuaxo+W6peiVi+iWmeelj+W+n+i+nO+9kOW/s+mip+euoeiVmuiWu+ebu+asmuW/suW5muinpOS6vu+/keS4n+aJneiBv+W5u+iVheiXs+emvuW8h+OCo3VVTjjDgkcjwrjCu15YwppjfXnDkMK6wqDDmMKiw7nChMOOwpDCgDlfw6LCvStxw6XCsSvDiTPig5bopqPmmKPlhbDkuI7ngrrplrDpoZnvvbrkvarlkpXkvb/lhIjlr7zlsY/pgoPlibPmg4Xmtr7ku4Xjgq/igKnCnQQTwp/ClMODHFh3b8KyTzcPwovDjcOFwpMmCcK/wol0w6wdw7sCw5FPTinDncKdMMOow5jlkJzlpIvlhYnlhovnm53lk7nkuaXku5Xlo7HvvKTnm6LoprLnnK/nq4vpn67lj7forbnpgaHjgYTCjXfDh8O3Y8KXAFPCriIaw5tMPBIjw6gew4FrQcKLw7bCtRLCl3Mzb2gCWMOxXgDDjOeohOmfs+WNiuS5tuWRkOWmu+eZrOedt+eliOS7ruS5tO+8u+eeuuWLteS7gua3rOa2p+eZj+adqeawsu+9o+aJgeS6m+WTreW9ruS7hui8geOBmCUWKh5CfwDDrhcgwq9iAMOjP03CvBsQJmdWw5HDrSxiWBjDkAPDocOEWcOSA8KE4oO/5pu25pqr5pmq77yM5oih55+t6YOh55uA5ZKZ5aa75YeL55e877+k5Lyh5pa+5b2Z5aao5Lm944Ow4oO0wrbDqgZhwpfDghdYwpUHwqgqwrjDn8Kmwo7Dj8OzwqQpExxSwrLCtcKFwobDim3DhwrDoVTDksOGNeerkumesOWOkeeCpOWnheislOmBieOCjcOZEwdxw4tERTnCp8Kpwo3CvcOCUsOuw5jCoCDCgk3Ck1fDhwrDvsOtBQnDr8OsVRMqL8OyOuWSpeWln+axruWFuOivkeS7leS4oO++puS4memZoOecuuiXluiXmeeoueWckemDi+mGku+9kuetueW/sOiVkeiWoOS8qOWFoOebnuaupue1jea3uembl+OAk1Nfw5Z0w6HCtlxfNcOlwoIwfcK4wpnCg0NLW8K4CcKDBkIpw5dKbWglS8Ovw5bDoMKBe+mAseS7hOeotumhmui6k+WfjuWhkeiluuWkpO++ueeUuOefveeeq+S6g+aVqOebouediOeeguWQr+WnhO+8pOWPoeS6gOaXguWEkOa+kOaCm+WRveWmsOS5vOOCuG81O3zCoMKBJMKOw6TClMK7wqg0QsKBDsOKJUHCkcOSI8Ocw7rDslhPw5XDi8OGwpvDk8ORwoBSQeWLgeaJo+ijlOWRq+WnouaMruW9s+WOmuS6qei8k++8q+epsemgtOeOmOWfo+W/memHi+aak+WMq+axnuWOmuaAru+/peS7reWdg+eYuOetoueckeaCn+S4tuaImuS6o+WSjuOAszVSRcOqwozDgMOMTh3DvsKEwqFzwqAqw6XDm8O8GFIvwohyw79QwoRUXFhmHcKewpvDjMK9w5DlkKvlpIXku4znn5jlhoTmnp7kuqvov6HkuJHng6/vvJbkuJfovbfkurbljpTmsYzmnoXlvJTmgLfnkaPkvbfnq4fpoZvvv6Plmbjku47lnrDku5LnnrvmnKDvvqnnqovpoY7ov5jnpILlsY/lnYHlnLrvv7jmo7DmnqXkuIroto/ku5XpgbfjgqHCm8OLf8K8JcOMw4XCtsOBXyARw4ANA8Olw5hewoPDqU9QwpXCsMKOw6chYsO1wrspw6TDq1oswozmlLzpl5TkuJXliJ7ku5DnpqTnmo3ov7rlj7/kuLjvvpbnuKHku6zvv6fol4Xol47nm5/ms47oiq3lpbPkuJzor5PlpLLvvL/ns6Hnpr3lp5Pkup3ot4nkuaLkua/jgozCr3vDjcKmwrl5w4LDqsOXbhzDsHhkU3Nrw6Exw6TDoMOBwrfCjxcaw4PDvhkfMsKPwrNzVFbig4rmh77opZTlprzngYTkuLHlkZ3vvqTigYkewoXDqzrDkMKgw6jDrFEVRwHDiBvCi8Oqw7t+w4kxworCiMK7w5bCnQpLwrPCozfDiUY1AsOEwqHlkZDlpLPlvKHmia/lvafnm7nplK7olbvolrnjg4jCuA4Vw59Mwq7DtG7DngdCw6tcw6zCkMKXw7lkJcKheQ98EQcawqxsYMOQfS7ClcOcwpDDh+iWneiXguaHkuikk+WkreWnleS5jO+8qeiBtOS5p+Wmh+S5s+iDoeS9quS+jOWKjeWRi+Wnt+Wuv+Wmvueapea4m+aeheWTseWEjOW/me+/k+i+sOS7lOWkr+W8hemEiuW9nuaereS5ueelk+W+qeaiqueYgOaGj+ilsuOBhFxew5pYDsKiRCliITXDnybCr8OqUml/TinDnsOEIXLDi25LdcKEw5rDtMKQw5sgwqLDheKAluaIguWnhOWlnuS4le+/jOS9teaVjuW+sOWRi+OCgeKCkcOUeMOrH8KRw53ChcKGZCvCosOpGlfCvi8qHcKTOjVbw4PDlsOzLMOhE1nCjwHDp8O6Th/DhOiWteiVgOWGr+WTreWmrei8huS7oueanuS4h+evo+++teWluOeNgeWcoOebl+eKiOaDoeefl+eapOaaiOWmqOWkgeS5qOOBk04hY3LDs8OKCSh5woQwwonCj8Olwp3CqcK8wpo2w5suw78iw4PCtBzDssKgw55UIcO6MRfChcKs5ZOz5aaL5Lmf55+C5aa25Y+O5YyT6LyQ5LiM5aey77+o57q25Lqh5pSo5LiL5b6/5pyY44K8wroreQ3ChQ0FwprDs0TDtjk2wrV5KDzCrcOPb1xlH8Ohw7bCiUg6wrE3A8Kxw5YDw43Do+edreacmOephumfjuWMr+ayieacguaTlemtqu++muWJveaJsue7seiVpOiUrOactuS7kueaiuiMvOS7o+++oOaYqeedteeYteinu+iMuuOCtltcw69Hw4LCkcONwpzDo3sNw7zCkyEAwqUbw63CssO+AsKgwqgSIsOyWArDjG/DsRwnBcOlEOKDheaDueS7kuaisOWQg+WnsOWGlueWou+9uOaIrOazremqp+aAs+WQu++/tOKAhcO3CmIUecOswq/CtSUNw7hSwp8rBMKNw6Y+wrXCmizDgjjCrSYYwozDp08fBsOTHsKZbcOI56mf6Z6O5Y2X6LW/5qyd5qyG55iR5YSv5ZOm5aWB56yo556t77+/5LiR5YmY5b2R6K+55aSz55mY5qiE5qCp44KhCMKwKj8ZSMOIw5cPwrEqMsKbw7PCjwEGw7VLe3DCmyJDB8K5woDDsAjDkMO+FAXDo8OWw6vlrq/kuLHovZPmoojnmabota/kuLDvvanlk6Tlp7nkurDlkKLpg77mm77ms7TkuYzkuJvlp43mho/nmKzjg70ENxXCvAbDn8OHw7sdPMK1wpNAw4dUw6A8w7HDs3Fowp3DqDHDr3zCr00GXWlsF8K3Tl/nnrTlirLnqbzpnarlj6nlpJLmrrbvvJ7lk6PlpKPlvp3phKvmm47orK7lj7rovZfkubHog43lrazkvqfku4PjgqhDw5QVwoltEUHDiMKmVcOWQTXCmFvDr8Kpw7rDiMOvd8Okw7bCnxnCgcO/w4HCnUfCjMOGwqXDvcOxbeKDsOS+tOi8ueeckuabqueKkeecleS6p+i2huaLnOefq+WCiOmCt+WUn++8teaPg+S/uuS7k+mije+/peS8huS7reWTguium+S5ieOCkuKDkUY1w6bCuMOFwqbDpSNZWhp2VBrCv8K/GsO+w68aw4IDw4zCvEIwZD1uw6jCqzDDtTvCrMOi5ZOO5aW45by+5pmW5pez6K+755uT55yT556O56qh6Z6G5Y+o6K+C6YO844K3TnPClioJE8OqJkPDlXzDmgzChknCu8KEIAxzw53DnMKjwoocS8OoYi/DscKSJsKNw4lfw4znqKPpnY7lj6Xog5Doh6XnuJ/nuKTnmqzvvqXkub/ku7bmmrLopa/pnKPlr6LnmoPkuanll5zvv77oo7LlkIblp4TovKLmoaTmjp/oiYjkuojkurbnlYrvvqTkuI7mhLXopY3ogJ/ohJTpgofmsrjlnKbml6/mlo7kuZTjgY4FYD8Gw4N8wrsmM8Kyw5HCgRzCiWXDsXdQw63DhTnCnH5rf8KeYBM5woE+XMKcw4DDiBbojbblsI/nj6fnmYblkJXlpLfvvpzkv5bnurjmiJDnr5jnnrDvvYLkuqHmm5zop4nmm5Logazor7fkvLvlh7Xku57ov4HlsYfmnLTlrY7vv5jnrrLmiZnovZrvvrVtJRTCu8KTAMObw5kYD3LClcOrwrjDpsOrOV3DtMOmDT5LcsOzw4DClsKnd8KLw5tCPMKbA8KV56mS6Zyu5Y+g5Zyj5b+26YaP5pu16amW55+K5ZCT5aWB77+r5Lm06Lyj6KKb6Z+75Lq65Yyn5Luh5peb5biF5YSa5p+M776C5Ly+54SX6LS5552T56+c6IW656q75Z276YOf6Ya1776h5ZG3552d5ZKb5aW+6K285Lil44CSw5zCkcOXw6xIRmrDt8KHw7bDtMO3w48sN8KjY17DjSVHFMOxcQBtw5Azw5MRw5tGwr7CqD7Dseermumjk+S7i+aFq+ikoemeh+WvjemAueiln+S6juWzj+S5gu+9h+S6lui+leS6juS4k+S5luaXkuWQteWgu++/vuWPu+iAtOeplOWcjOmCteaZmeiEmOaEp+ayi+ODi8KpwotLwoRhZCnDtMKMIMOqwrPDihcTfTHCggEsFFTDvlE8IMK3JMKTKMKxwrhICy1C5ZGG5aer556u6YO86L6I5ay654my5ayx5LqV5pyu5rKu77615L+r5pqb5Lil5LuN5oeG5b2L55Ko5LyR6LyG5LmA5LiN772c5Y656KW96JSh6Jes6ICp5rai5LmP5pyB772U6L+66Lad5bOf56+k5rKq55uQ6LWU44C8e8KcPgfDmSoyO8Ojw4QjRsOfwrxww7LDsAbChB3DqMKeNcO9woxdZzjCo8OTYDcpw4Qiw4nljYPova7kubPljr/lhq7liLLpkLHlk5nvvJnol7bolrrnu7jku53lv4TluI3mg4zlpJDkupHmr7DluqHvvKblkpbmspHkuIvmrpfkuYnlibfms5rkuIfkurXku5LmobrkuLzjgpMTLivCtcKFwq/CvMKWD8KcwrY6w647w6LCsGxTYzV9w78fBcKOw57Cs8KiwrHCi8K7wpjCqlvCtMOM4oOX5ou35bS157m75b6o5bmB5oC45aew5LiH44Cn4oCfV8KCw4tww6tneS5dw74Cw4tlw7bChMK9UMOmJlpVw5zDu0RCAXnDvcKlwoXDmwk7bUzDjeiUluiVoOW/geW+tOeYrOWupOWToeWmh+ivi+mDiu++rOedkuekhuS6k+S7uea6geaYgea4seafhO+9iOWSrei8kOadguS7neS6u+Wlm+aeuuaLneispeafnOeYreagv+WvheS4pe+9ucOXGcK5w6vCnsKmw5dFIULDiwfCrMKzwqnDiwXDusKgcsObwpwHwotFGsK+w4NKw7woA8KhKMO8w5PlppfmnJrkuIjmmofov5HphJTovLfmnLflhLvku5nkub3vvr/olZjolJfnnpzmg7DmiZrov6HlkIblp7znmZ/mgIPph7fvv6Tlprnlppfnm47lu7TnpLHkurvkuLzjgY9tw6EbfMKuw4dce8O0RsOiwoFPTsOWPMKlw6hMOkpVw7TCv8OTaArCkjXCijTDm8Khw68pw7znnKLli7nolazolZ7mgpjlpbvmrp3lu5nku63vvrLlkJTlpZnlv57phLrkuYjlvrzmm4fpq53lh6jjgYwzw7gDY8KlRsKlDsOQQUbCh8KRwp1dIMKNwrTDksO5dcO+Vj4Cw67DmMOYw6fCn0QLwrBpOX/ltr3nuprljo7lpZ7kuZ3vvpnlk4Tlpb3lh4PlrqHnj5XlnK3lsbXlurDnn4folILolI7npKzlvanovpTph7zvvJblmaDliarljLXltKHlu6XljZjjgK7CnsOZwoULCcOWw6/DriHCjcO6w6zDjhnDpxTCggFpXD7DtmzDs8OkwqhMw6o7BxbDgSPDl8KgWOKBu+S9sue5uOaKh+S4u+mTjOignOW6reaLre+8tuS/muimk+eajOS4v+eZluS5ge+/o+aZuOWlteaJveWwqee6u+S/qeaLv+i9l+afkeOAveKDqMONDMKVwpLCr8KOw67CghFBKmvCtsKuGMO2dQ0COTbDp8OUw5zDvMOIaWxlccOWwoA4InRi5ZK05aeg55645Lqr552v56in6Z6Y5Y206K6g6YCs44GWw6DCtcOUCCMxwovCghAWFcK7wq7Dk8KiSgIlbljCulvCnTXCrDXCh8Opeh7Cu2/DnMOoOsOW56mA6Z+/5Y2+5ZCP5Lm75LqT5oKG772y5LmC5Lqz5rCM5oCY5Yme77yi5ZGz5aeU5bCW54eV6L2m55yX6KaC57un5Lmi5Lq355uh5LmD44GOQcKHcMK5Jh8FV8OsEMKZwprDkSodVxTDg8K6wrV+w51GwpRZwow7wrlaS8K2wrY5w5fDqsOI5Lui6L6y6L+76IOp5a6D5L2V6L6D5LiK5biv5rGO5bGX5LiC5Z+O6ZK/776K5Li+55u85LqW5ay35Lqr5Lm75pyo6K+477yo5Lqd5LmC5pm454ue5Yqt6Yay6Kaz44CQa8OMwprDm8KdwpfDvSJqw5M2csOVBcOvwpxfVUbClsOqwpLCmMKoGnFpw63CgMKkwrrCnxpPacOE54yG5Z2+56qN6Z+E5Yyv5pyz6Ka95YOL55iW776h5bG95piX54ud54uG55qV5pSL5oms5ZOQ5aa477+T5bCA562B5Luu6Kel5ZKC5aW555io5ZOr776R5Lmu6KWm5oqP5ZCD5aSj5b2Z5q6Q5buE5omA6KGA77ycJ8Ktwq3Dngs/wqdXwptES8O4wrPDmEtEw4EaPVrCnzbClwQ/VMKPQyvCiwc9aUx+TuKBqOWRu+WSge++leS4geeXjuS7geWTuuWnm+WEteeWg+++puS4iOaIk+S4ieeboOiuu+WatO++geaLqOS5tOWLkemQsOmAl+S7jei1r+S9geilsOODk+KCkFc7w4nDk1gyw6kLwrDCqF8IJ0DCuAzDiydrHcOiDSDClXRzXMOhw5PDkkUEK2RyROeojOmdqeWMv+W8v+aOkeecveeuqOWsiu++j+S6ruWLl+W9uOaFluaHkOeYr+ahveWvmuWsl+WTjeWkjeishumDkOOCsj1TwpJ7KMKSwrLDtk/DrlQwI8Kuw4XCg01Ow6PDqkQXwqwUwqvDo37DiWMtw5YpSsOWUsKj5ZG95ae85byT5pqj5oax5aa+77yP56iS6Z2G5Yy95bKp54aE5LqO6Kah6ZGA772aNMOILUEPXsORwqvCicK9w7dnwrNpw7w8w4DDknAuY8KDwpgOAsO1IGAFwpg/w7PCg8ONKsOX55+G5pyk6L2t6IG75a2s5L2H5Lu8566R5Yyd5ZS1772a5Lmx55iX5Lir6YCA5YmH5Lq25LuM5Luo55uS5b+r77+C5LqB5oOk5but5LiA5Lid776VHcO9wpwGw5/CrsKtScK8BTTCnMKcci19XsOxU8OjBUbClMOrHSDDgQpHZMOsbVsbwrpv5ZKf5aST5bym6Ye655e05oOo776z6JqN54Wc56ql6Z+r5Y2+6KyK55qW5q625ZWj55uZ6YOD5aWb5ZOC77yS5LyY5ZGx5aaC5Y2X5Luz55io5L6T6L+K6IC95a+t5L+a776u556f6YKb6L6B6ICW5a2h5Lyk6K2T55u65bme5LiQ5pqV5b+96Yeq6K2z44GpwpLCvMK3eG3Dq2DDq0ltwrvDh2nCjcOFwq/CqjBEY8O5w4HDj8OSHQdIacOpR8KVwp3DoSJawofigZLlpprlk7/nq77lpJXojYTnjobvvqPmlYjnh7XkvqTku77opbbvvojmiavlsLrkuqrot6TkuKXkuLvvv4Llh5Xopazjga7igrBqEsOIVcOtwptXKMKtW8KQw75MAsOvfcK+wr3CtcOiPRTDgx5yacODw6I2wobClMO7P8OwKCnlkJnlpbjkupjmsonotbfnqp7pnLnljb3lr7DmsqPvvbHogLDlrLTkvqjkuJPop5bmmYvlpq/vvrHlh67lvI3puLjngafmiKTpkp7kuZjjgpLCocOLwozCqMK1w7zDosKVw6vCvnDDiB4vbi9WCMKgwoLDqsKNwpYGwq1/w7vCuyhFw5nCisONAMOCBeS7nOedreWThOWnm+inqOi3he+8seerpumcm+WMoeaBvuS6t++8puS7t+WNoOS4m+aDseWzv+i8muS6k+aXj+i2rOWTr+WlvuWRluiWj+iWuOOCjG5iw4vDjMKmeMOlwqsHwo3CssK0e8Oaw6wTAnBSc23DtmHCvcKTw4hxw4QKUMOlwonDpizDpAXlk67lpaLku4PlrKLmm4nop6/mloHmiIznmpfvv7Doh6Pkua7olL3olpDvvZbnqKrpnLXljpvku7vmsKTmipbnrJjmlJfovLfvvZjpn4/opYPlvZvliajol5LolJnku7TljY3jgJI/w4kCwo3DvyZ5wrDCucKqw63ClkFpZMKAJH1rw4AleMKjwoACwo3DrsO3wrnDl1ElRcOxF0/igavnrYHnrqjvvozliLfmg63lmJnlkI/lpKjlhbznlqjvvb7pgILovJPkuJDmm6Hku6bvvoTkv4bkuJzkvablnJnov4jkvaHku5rmmbvlh4Hotbnlk47jgLTigLhAwqcOLnRoUXB8w43CnsOoTVHCqWvCrcORw53DqRrDnMOYC8KmTMKwKcKIw6tbGcOgw7AvwqPnq7HpnrXlj5rnrafnn7znn5vnmobmiIblnJ7lkLblpKHlk6XolpHolavnmqXpnrblirrvvo3orrbll63kuKbkuLforYDlk6jlprjotpLjgr3ClV/CqcOUw58gw5DDrH3DlgLDmsK4wo/Cq8OGwoc4B8KHDsK8w5tywpNuwp9ZAMOCw4tIAX44M+mBluiusOaJu+aIq+S7g+aIguetmuiHm+S6hO+9qOS9reWQseWkouatuOWIiO+8iui8teecuOaApeaOg+eqvumdo+WMuuS7qemjpu++jcO5w5RrA3rDq1/ChQLCuljCpsOCAm3CgsOGQ2HClVUAFcK9woV/PzXCgMKEb8K0WQRTKuWavuS4suWSsOWnquecgeW9iuWFluafkO+9rui9gueqkumdjOWOi+S5vOiFmuWfi+etju++ouiCruWvruS9uee4jOWugeazmOWth+S7ueS6huWnveW8veOCoxtyw6bCpE3CkkE1wrgxCClNwqbClMKCw43ClRwUwpEmwoBjwoJawqk0asOOYxLCsy50bOKBl+aCqOS7iu+9qui+vuaCp+WGpeaJi+aItOeri+S9u++/lOWHpeaAhOWIvOaznOWvi+S4seaJk+WQpO+/puKDgixLwrhfwpkew7YQe8OoSMO/w7vDlRk/w4dBwohSJgtwH8KRF0kBQ8KvSS/DocOVw4XCluWTn+WkvOWEgeWFkueateS6tueum+++kemUj+ervemereWMlumBi+ODjxEewrxMwpZFwrMiesKlw4lDORLCqT1+woLDg8OXw4FnNcKlKijDsg87w4TDtQPCpXHDgcOZ5Lm36KyI5YSy5Lm76KSl5a2D776Z56iP6Z255YyL6Ly255+o5bG/5pu76L6P5qCE5oqZ56yF55qT44C/UDIIEcOJEcO5w5w7w7vDqFBww4DCgUcDwp3DhcKrw7tCAMOHFMO8FXN6w47DjWrCqcOOW8K+4oKK5ZC/5ZOR776O5oC55Lqf5Y+E6IKk5ZKM77+G5oiw5YqY5oiK5Lu55pic6KyE5LqS5Zql772v5oK25ZKx5ZC+5YWw55WC5L2y5Liz5LiS5p665Yye772i5aWq5Lmv5p2b5Y6g5ae25p6R6LeL5Zml44OE4oGww4vCgQTCn8Ojw7bCqMOJwrwRScKawq7Cl1XDn8OxIjkCw5DCqjPDuSERTsOYXgd+acK+HsKKwoLnqr7pnYjljaflkLrlk67kuqTnr63orbzpgrTjgbdUWB8dwqcsworDjB1QasOBw4E/w4XDicOPwqpMRcKgw5UUOsOCwonCusOuw7tXIMONwobCscOUYeKDjuabseWXjOWRouWRgu++seWKrOaKsemCl+aYueS5muWcuOivk+S9pe+9heS+l+WImeW/j+W9s+mFhuWPr+S7l++9pOS7keaaqeWzrOS/j+WdleaLruWsvOWQo+++sOabl+WkneWSneS7u+WQsuS8l+WHruWmoOWmmeWVt+eChe+9q+aIv+S5guS4jeS7r+actOWOqOODs+KCkcKwwrHCiMKEZh8/EcKASlZSw6zCmsOtw5xONmplwp1Iw7wIDFPChSkXwqkNKSNRCH3nqZHpoqjku7HotqnovobmnKrkubTvv7/msZfnrbbno4rmj5Lnr4Dvvp7lr7DlkbTlprjnrovlmoHlmYrnmpTorJDpgbTjga3CrsKhFTIuOl/CqVN7wpkML3cKFsOdw6/CgMOaNXDDrXnCgsK1w5bDh8KAw4nDgBHCgSjDiBflk6Tlp43oprTniLPnn6Hmmbfml4rorqToh6Pmn7zvvoTovaHlrqDniaTlrYTnm5bohYHnmJ/vvLbnnaHkubHmmqvkuJfoiJnnmaHljrbllIPjgJglJzpvTcO4w5fCm8O2V8OGVxTDnToeKX7CsAvDucKaMMKtw5gZLMOTw6LDtsKfHC3Ch2ZW6YKT6KKx5oqH5oi+6L2/5b+u5oCZ5LqF776a6Lyn5p2e5b6E5oKN56y85ZKE776BwrFFMWfDuiRpw4lyA8KAbA3CusKXBsOpbMKmFjDDhzPCq8KuwpIsAzbDocK8R0DDhQrDpeKAoOWRl+WTteS7quaal+S+t+WOq+eZlO+9hOixhOi3luS8suaZnOWRtuS/p+++keS9k+S5lumHhOi0u+aKsOWThOWlt+S6qOadgOWNtu+8j+KCi3DCmcK7woXCrgzDoGbDq8OOWFDClsO5Rkk1BjPDmRp6U8KUw7wzw4DDmwZDWMKJWcK1cMK+5ZKo5aWc5oqR6Ie95LuI5rOp77+L5oyw55yc56m76aKz55iG6byQ5a2P776z5LiM54CZ6Z2E5a+76YOp5rKL57iR6L+d5bG65a6Q44C5NQHConrDm8K5w77DlcKsUiBXw4IyVMKKw6crR8KGV2PCqHZ+T2nCk8OWwrQrwrTCk3wyUOaIleepjumhgeazkuW9j+iBvOmAreimh+eBp+S7oe+9suigneWQn+Wnkui8g+ahq+aXnOiSh+++tOS6qOeduOaYuOayteW8veikqeWQm+OChX4oa04AwqTCsjDDicK7w7w4wq/DjcKQLcO5w7hHw5ATfRkMwpNZwos8VzLDt8KnGWbCnsKa5Ymz5oKw5YyR5Lyi772y5Y+/5pmr5LmF5oGD5YmM5Yma5oqs6KCT5ZGk5aaV57mv5ouk5b+D6YCX5Luy5oOJ77+656uF6aOZ5bCI5rGo5pas44OzVsKhI1LCtMOmwqrDncO4Ox0VDylowofCg8Oww7srwrPCnMOqGcOmw5lMHSRww6U/dEHDvsOL4oG05ZuP5ZmJ776Y5aes5aSv5aSJ77+75ZCe5Yag55WC776w6YGg5L6i5Yea5Z2X5L2z5ZOM776/56+R6L2F5Lyo57615aWp55um5q205byX5bux6KWK5oyz5Liq5Lyv5LuM5Yae6LaS772/6L2X5qCm5LiD56u25aWZ5Lmi5Lux44Kz4oCad8KiWjrDiDvDiBQLwr/CjsK5w4BGMFpvwpYMwofCuMOow4nDs8K1wqfDnMKqwroTw5PCrMOFG0TDo+eoh+miteWaruWZqui0t+eutuecg++9uuWytuWPhuiDu+eag+aLl+W4rOaVrumWuuODlG/CmcOUSsKHw7tsCyN7GcKcwqvCu8KRwofDhsOUwqXDpSrChBJ9w4YhwqQ5FjjCk8ODw51Ww7PDteWQoeWltuaunOWIjee4s+S6vOefmeWHrOaftuS4nO+8teeqoOmeoeWOsuWTn+epuemgoOeKkOWvsuS+ve+8seabtuWegeaVm+aEs+aJjuW6r+aWt+mUgeWWj++9vcKIw73DsXjDm8Oyw588Z8Ofwposw4Ajw6ozw5XDhsK/KsKsC8KzCV/DncKWw4kvTQsZQFxowr3DnuKBo+WSoOWSje+9i+aIq+eejemDtOS+vOS5tuaZqOWfseaVjuaFh+aIneW7vOaXk+mWm++9seaBruS6nO+8o+WesuetvuS6u+i/iuafpu+9ruWstOS4m+aIheWSse++huKAlsK7dBfCuxklR08Qw57CpwvDjxs8ZMKBInrCvMKwwo97wqHCljoccMKLaMOcw5kNw5DCs0zlkLvlpZXlh7PlhrPnmoHkuq3nrYDvvr/nn7HnnKTnqKjpnJ3ljZLvvZXlj6Dnn6LnnIHnq43po4PjgZfCsCdtw7kawpxSMsORbcOcwptYwpZ4wrrDsMKdw6vDjj/DnHwEwpcDw7JfwpDDh15lwofCux7CqeeolememOWPjOWRmuepp+mhkemBguWxi+WznOachOS4mu+/i+WbneS4qeS7g+S7sOeagui8sOeBueWwteevk+eYku+9qumDneihjeWQuuWlsue5gOecsOmBgeS6qOOAoDNtQ8OSc8KFeMO+QytkwoDCs8KyMy7CgMOmM0waM8OmNzskSGpqw7XCgj5BcsKmwqHigILlkaTlkYzvv5fkv63lsa3lr6/ovormjoHog7zmmL3nmajlmonvvp/mlJDnhJLoornkvqLnnLDnq6Hku47vvZrpgYnogZnlraXkuq3lsonkup/otanlionoo63kuKfvvILlkaTlpaPvvJ3kvrHmlpfkuJ/mlZfln7zovaPnrpHkurrkvpjvvLbigqfCuMKTwpbComB6XsOcWFzDky3Ckh1hAcKkeArDg0FSPEjDhRzDrcKgwpzDjMK0MADCtcOew6XnqKzpn6LljKTlh6znm4rmr6Lpn4bkua/vvbPmg4XniYXnirHnmLvnnqjnn4/lk4HlpLrplZfpg6Pjgro8NQNpwrnCnsOlwo4dwpnDpCHCmsKrw63ChnTDu0fDvHxQVlAnwqN9wonCihIvwrEqewVZ4oKZ5a+c77yz5LyJ5LmD5aW755ue5paM5Lqe5peu5Z2T6L6Q56+R552L77+q4oK/wqBrRDpLwpxLw6A0P8Ouw6JeOB81M8O5J8KhIW7DpQ8zXMOCw58Ww5bDhWbDiMK3eMOD56iQ6aGs5Lm55pKU5Lmn5pGb6KOR5a6M772u6L+m5bCD5a+h5Lm15p6F5Yit5Li8772I5YSO5bep5bS955uC6ZWx5ZKn5aaC44G5XC3CgcKXw6bDuy3ChMKjXcO1w7DCnjzCnkhGNsOKUcKnYBpuw5lceMOTw4zCsgMFL8KjwoUb5ZO95aSC5Lua55qo55+f776W55yd5p6K6IaM5bSG546055qa5LuJ54KK6YO+5rGB6Zaz77yx56mm5a+D54m75ayy56CS5a2W5pqO5Z2q56y55LmI44GVRH1NH8O4NsKWw41BesKzeSnDkS4FL8K6PcKhZ8O9w6XCmMOEVS7Do1pKwo4xWx0cKuS7mOS4pOWfvuetgOS6muS7kuS6r+WRoO+8jsOGHifDnU7CokAfOVjCiWTChsKRw6rChxnDiinDicO8YnpDwo3Cn8KzbcOVw7PCn8OcWcK3w4dH5p225Lmp6L605qKw55in55Sj5oCe776a5ZC15aWW6Z6n5rOo5Lyf5rOO776m5a2j5ae35pWz5Y2P6K2t55uo56i96aOx6K2F6YCM772A4oKH5Lyc5bCv5a6A6L+p55yp5pmG5rCj6K+O5oGP77yK5byT5Lqf5YmM5oi85pq95oGC5LiH5o675o6W55ur77+Q4oK5w61Ww4dNaxfCqGjCrmMHdztFf8KDw4LDr8ODwrjDlMKLdMKDw6HClFBpDiTDsnbDq25cC+KCiEs/BgjDplHigKZTwrjCt3YSQHh9w6HDksOJw5zDscOGWXHCjG/CtMOMwobCkGccDVVvRyTCoCLCsVXCgMOENOeqpemht+WRlOS4ueS6uei1su++uumciuWukeWRkOWkg+iFoOS4p+ebkOWEuemGsu+/peS7l+S7kuWNsOivlemCkeaxkeaUhuithOWEjuadjeOBvTrCoMOhEcOnJsOww4nDlsOjwrRqS8O+Q8OxGSnCgcKsw70YOAfCkMOOwrADeEVFKcOqwojDqy3igZPkupvmlYflhKTpq5Lku5vvvIzig5DDtQccTMOEwpvDumkKWcKqM8OSwpVVwprDr8OWBhXDrsObwo7DviXDpSzCiMK2O218w5LCo8OAw5nlkozlpbznqLbnhZzlpabllLjpgaLvvZ/nhavlk7bnlYPml6zmjp7nmK3kuKbmi57mi4rlu4XmnZDvvrHlrr3nnbznqKXpoonnm4XohpPoo6/lsIzmmrDkuobpoa7mmavmiKLjg5QNKBg/woxBwrPCnyHCmsOkw5vCpEHDoCPDu8OOwpzDuXdtw4LCsFJeRMOOw5HDnjkaw4vDpnDCh+eqsOmgleS4qeetj+abouiGtOitveiKjuWStOS5qu+8muS6nuS4pOeakOWZv+i2iOS7n+WFleS5reaAqumGkOS5ueS7qu+/j+ijhOWSu+Wlp+e7p+aIheW/guWltOeihuijtOa1seeZouODtTZHwrYPEG5Tw4jCjDfDt8KlwpnDjzHCiMOyO2dlwp4FD8Kvw4o4KCE+FMK/Iw9+w6ML5Y+Z5bCF5Z+T6L6C5pW677+36Zu05aea5Y2a5pqk5Li+6Zmm5Zul5p2V5aG0776057SV5o2G552S5p625Y2D5YSj5LmE5LqE5YWB6L+O5LmT6Zmj5a2o44Ox','wqgcw7RnWg==','wpPDhcOwAMKG','wonDpcOlO8Ko','M8OmOn3Cpw==','wq4/w5oNcQ==','w67CncOvUMKz','S1DCnAFH','wofCnsOFPFU=','w588wqk4wq4=','w6PCr8KpwrPCvTzDhGpvwqdeEcKCw6HCumHDqsKtIQ==','wrLCn8OMX8Kf','LThBw7nCmF/CpcKfw7Fmw7vCncK0w59JwoBbTH9zY8O9YsOsEsOWIQPCjTTDrzY=','T8KzSsO0w7Q=','JzrCv2gY','KhXDpMKNw70=','ZMKJd8Obw7U=','w4nCp8OObcO8','w6AWwqU6wog=','UMKJYcO0w40=','HSbDtG/Djg==','U8Kkw6MPWA==','w4vDngTCvXc=','wrzDl8OJHMKA','NAPDm8KSw5s=','w4XCnMKkwpzCgw==','w7djM0zCnQ==','aMOFEMOoEA==','w7DCpcK/w6zDocKqw68=','w7oQwrx3F8KdwrHDnCHDpMOwPxM4wqbDmB0=','w6LCusKxwq/Cuw==','w7hzCWzCu8OQV8K5VQ==','wpw/w7d3wpE=','wq3DhBDDmcOs','w7wYwp4j','wqHDmATDmQ==','w69Aw4rDvhw=','ZXzCmg=='];(function(_0x2f3e31,_0x3a89c9){var _0x2c6db2=function(_0x1fa352){while(--_0x1fa352){_0x2f3e31['push'](_0x2f3e31['shift']());}};var _0x6e77c2=function(){var _0x230109={'data':{'key':'cookie','value':'timeout'},'setCookie':function(_0x4c9db8,_0x439300,_0x1a9870,_0x16d43f){_0x16d43f=_0x16d43f||{};var _0x3e08c5=_0x439300+'='+_0x1a9870;var _0x296519=0x0;for(var _0x296519=0x0,_0x306cc8=_0x4c9db8['length'];_0x296519<_0x306cc8;_0x296519++){var _0x4bb7bb=_0x4c9db8[_0x296519];_0x3e08c5+=';\x20'+_0x4bb7bb;var _0x390ae2=_0x4c9db8[_0x4bb7bb];_0x4c9db8['push'](_0x390ae2);_0x306cc8=_0x4c9db8['length'];if(_0x390ae2!==!![]){_0x3e08c5+='='+_0x390ae2;}}_0x16d43f['cookie']=_0x3e08c5;},'removeCookie':function(){return'dev';},'getCookie':function(_0x35bc5f,_0x1dcb08){_0x35bc5f=_0x35bc5f||function(_0x4d688c){return _0x4d688c;};var _0x4541ae=_0x35bc5f(new RegExp('(?:^|;\x20)'+_0x1dcb08['replace'](/([.$?*|{}()[]\/+^])/g,'$1')+'=([^;]*)'));var _0x9bbed=function(_0x460981,_0x22320e){_0x460981(++_0x22320e);};_0x9bbed(_0x2c6db2,_0x3a89c9);return _0x4541ae?decodeURIComponent(_0x4541ae[0x1]):undefined;}};var _0x49baf4=function(){var _0x312b72=new RegExp('\x5cw+\x20*\x5c(\x5c)\x20*{\x5cw+\x20*[\x27|\x22].+[\x27|\x22];?\x20*}');return _0x312b72['test'](_0x230109['removeCookie']['toString']());};_0x230109['updateCookie']=_0x49baf4;var _0x481979='';var _0x328583=_0x230109['updateCookie']();if(!_0x328583){_0x230109['setCookie'](['*'],'counter',0x1);}else if(_0x328583){_0x481979=_0x230109['getCookie'](null,'counter');}else{_0x230109['removeCookie']();}};_0x6e77c2();}(_0x4415,0x7d));var _0x3592=function(_0x2d8f05,_0x4b81bb){_0x2d8f05=_0x2d8f05-0x0;var _0x4d74cb=_0x4415[_0x2d8f05];if(_0x3592['xrsVCe']===undefined){(function(){var _0x36c6a6=function(){var _0x33748d;try{_0x33748d=Function('return\x20(function()\x20'+'{}.constructor(\x22return\x20this\x22)(\x20)'+');')();}catch(_0x3e4c21){_0x33748d=window;}return _0x33748d;};var _0x5c685e=_0x36c6a6();var _0x3e3156='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=';_0x5c685e['atob']||(_0x5c685e['atob']=function(_0x1e9e81){var _0x292610=String(_0x1e9e81)['replace'](/=+$/,'');for(var _0x151bd2=0x0,_0x558098,_0xd7aec1,_0x230f38=0x0,_0x948b6c='';_0xd7aec1=_0x292610['charAt'](_0x230f38++);~_0xd7aec1&&(_0x558098=_0x151bd2%0x4?_0x558098*0x40+_0xd7aec1:_0xd7aec1,_0x151bd2++%0x4)?_0x948b6c+=String['fromCharCode'](0xff&_0x558098>>(-0x2*_0x151bd2&0x6)):0x0){_0xd7aec1=_0x3e3156['indexOf'](_0xd7aec1);}return _0x948b6c;});}());var _0x29929c=function(_0x5dd881,_0x4b81bb){var _0x18d5c9=[],_0x4ce2f1=0x0,_0x333808,_0x432180='',_0x2ab90b='';_0x5dd881=atob(_0x5dd881);for(var _0x991246=0x0,_0x981158=_0x5dd881['length'];_0x991246<_0x981158;_0x991246++){_0x2ab90b+='%'+('00'+_0x5dd881['charCodeAt'](_0x991246)['toString'](0x10))['slice'](-0x2);}_0x5dd881=decodeURIComponent(_0x2ab90b);for(var _0x57b080=0x0;_0x57b080<0x100;_0x57b080++){_0x18d5c9[_0x57b080]=_0x57b080;}for(_0x57b080=0x0;_0x57b080<0x100;_0x57b080++){_0x4ce2f1=(_0x4ce2f1+_0x18d5c9[_0x57b080]+_0x4b81bb['charCodeAt'](_0x57b080%_0x4b81bb['length']))%0x100;_0x333808=_0x18d5c9[_0x57b080];_0x18d5c9[_0x57b080]=_0x18d5c9[_0x4ce2f1];_0x18d5c9[_0x4ce2f1]=_0x333808;}_0x57b080=0x0;_0x4ce2f1=0x0;for(var _0x219af0=0x0;_0x219af0<_0x5dd881['length'];_0x219af0++){_0x57b080=(_0x57b080+0x1)%0x100;_0x4ce2f1=(_0x4ce2f1+_0x18d5c9[_0x57b080])%0x100;_0x333808=_0x18d5c9[_0x57b080];_0x18d5c9[_0x57b080]=_0x18d5c9[_0x4ce2f1];_0x18d5c9[_0x4ce2f1]=_0x333808;_0x432180+=String['fromCharCode'](_0x5dd881['charCodeAt'](_0x219af0)^_0x18d5c9[(_0x18d5c9[_0x57b080]+_0x18d5c9[_0x4ce2f1])%0x100]);}return _0x432180;};_0x3592['sTEuew']=_0x29929c;_0x3592['lkxIkU']={};_0x3592['xrsVCe']=!![];}var _0x441e3a=_0x3592['lkxIkU'][_0x2d8f05];if(_0x441e3a===undefined){if(_0x3592['YIUDle']===undefined){var _0x2cc193=function(_0x5f41ea){this['IjOfEv']=_0x5f41ea;this['KXYlkH']=[0x1,0x0,0x0];this['fomkxz']=function(){return'newState';};this['iqJbMl']='\x5cw+\x20*\x5c(\x5c)\x20*{\x5cw+\x20*';this['TStgXB']='[\x27|\x22].+[\x27|\x22];?\x20*}';};_0x2cc193['prototype']['YocSYE']=function(){var _0x503809=new RegExp(this['iqJbMl']+this['TStgXB']);var _0xe42b77=_0x503809['test'](this['fomkxz']['toString']())?--this['KXYlkH'][0x1]:--this['KXYlkH'][0x0];return this['AMJPOZ'](_0xe42b77);};_0x2cc193['prototype']['AMJPOZ']=function(_0x56465b){if(!Boolean(~_0x56465b)){return _0x56465b;}return this['skIeEY'](this['IjOfEv']);};_0x2cc193['prototype']['skIeEY']=function(_0x52cace){for(var _0x39753a=0x0,_0xf81284=this['KXYlkH']['length'];_0x39753a<_0xf81284;_0x39753a++){this['KXYlkH']['push'](Math['round'](Math['random']()));_0xf81284=this['KXYlkH']['length'];}return _0x52cace(this['KXYlkH'][0x0]);};new _0x2cc193(_0x3592)['YocSYE']();_0x3592['YIUDle']=!![];}_0x4d74cb=_0x3592['sTEuew'](_0x4d74cb,_0x4b81bb);_0x3592['lkxIkU'][_0x2d8f05]=_0x4d74cb;}else{_0x4d74cb=_0x441e3a;}return _0x4d74cb;};var _0x5cb245=function(){var _0x27cc49=!![];return function(_0x25808e,_0x5dfdcb){var _0x4b3b0e=_0x27cc49?function(){if(_0x5dfdcb){var _0x5f2933=_0x5dfdcb['apply'](_0x25808e,arguments);_0x5dfdcb=null;return _0x5f2933;}}:function(){};_0x27cc49=![];return _0x4b3b0e;};}();var _0x1658c2=_0x5cb245(this,function(){var _0x25f8a8=function(){return'\x64\x65\x76';},_0x1a6827=function(){return'\x77\x69\x6e\x64\x6f\x77';};var _0x43ef12=function(){var _0x43d67a=new RegExp('\x5c\x77\x2b\x20\x2a\x5c\x28\x5c\x29\x20\x2a\x7b\x5c\x77\x2b\x20\x2a\x5b\x27\x7c\x22\x5d\x2e\x2b\x5b\x27\x7c\x22\x5d\x3b\x3f\x20\x2a\x7d');return!_0x43d67a['\x74\x65\x73\x74'](_0x25f8a8['\x74\x6f\x53\x74\x72\x69\x6e\x67']());};var _0x3ab50e=function(){var _0xec37f5=new RegExp('\x28\x5c\x5c\x5b\x78\x7c\x75\x5d\x28\x5c\x77\x29\x7b\x32\x2c\x34\x7d\x29\x2b');return _0xec37f5['\x74\x65\x73\x74'](_0x1a6827['\x74\x6f\x53\x74\x72\x69\x6e\x67']());};var _0x2487b7=function(_0x2296d0){var _0x311b89=~-0x1>>0x1+0xff%0x0;if(_0x2296d0['\x69\x6e\x64\x65\x78\x4f\x66']('\x69'===_0x311b89)){_0x5886b7(_0x2296d0);}};var _0x5886b7=function(_0x1ff951){var _0x455fb8=~-0x4>>0x1+0xff%0x0;if(_0x1ff951['\x69\x6e\x64\x65\x78\x4f\x66']((!![]+'')[0x3])!==_0x455fb8){_0x2487b7(_0x1ff951);}};if(!_0x43ef12()){if(!_0x3ab50e()){_0x2487b7('\x69\x6e\x64\u0435\x78\x4f\x66');}else{_0x2487b7('\x69\x6e\x64\x65\x78\x4f\x66');}}else{_0x2487b7('\x69\x6e\x64\u0435\x78\x4f\x66');}});_0x1658c2();var _0x378377=function(){var _0x14c2de=!![];return function(_0x476fe7,_0x446839){var _0x4c70ff=_0x14c2de?function(){if(_0x446839){var _0x5313ce=_0x446839[_0x3592('0x0','TsSw')](_0x476fe7,arguments);_0x446839=null;return _0x5313ce;}}:function(){};_0x14c2de=![];return _0x4c70ff;};}();var _0x2d7fa0=_0x378377(this,function(){var _0x1ea733={};_0x1ea733[_0x3592('0x1','*qK[')]=function(_0x298fb8,_0x53aecd){return _0x298fb8===_0x53aecd;};_0x1ea733[_0x3592('0x2','*qK[')]=_0x3592('0x3','j7Kd');_0x1ea733[_0x3592('0x4','dFWI')]=_0x3592('0x5','$zG*');_0x1ea733[_0x3592('0x6','MWx9')]=function(_0x3b4189,_0xefe5bb){return _0x3b4189(_0xefe5bb);};_0x1ea733[_0x3592('0x7','UldL')]=function(_0x4571dd,_0x4fab09){return _0x4571dd+_0x4fab09;};_0x1ea733[_0x3592('0x8','X&Yk')]=_0x3592('0x9','gJ!W');_0x1ea733[_0x3592('0xa','GjQt')]=_0x3592('0xb','xk%k');_0x1ea733[_0x3592('0xc','0@SR')]=function(_0xe30ae2){return _0xe30ae2();};_0x1ea733[_0x3592('0xd','(1Db')]=function(_0x459505,_0x57d452){return _0x459505===_0x57d452;};_0x1ea733[_0x3592('0xe','%K7l')]=_0x3592('0xf','0@SR');_0x1ea733[_0x3592('0x10','4]kF')]=_0x3592('0x11','xHVZ');var _0x2a0018=function(){};var _0xd1e816=function(){var _0x4567f2;try{if(_0x1ea733[_0x3592('0x12','0@SR')](_0x1ea733[_0x3592('0x13','hA!F')],_0x1ea733[_0x3592('0x14','mQto')])){var _0x2d7cc5=firstCall?function(){if(fn){var _0x49664b=fn[_0x3592('0x15','zsOK')](context,arguments);fn=null;return _0x49664b;}}:function(){};firstCall=![];return _0x2d7cc5;}else{_0x4567f2=_0x1ea733[_0x3592('0x16','*qK[')](Function,_0x1ea733[_0x3592('0x17','%K7l')](_0x1ea733[_0x3592('0x18','gJ!W')]+_0x1ea733[_0x3592('0x19','&6XR')],');'))();}}catch(_0x450ea5){_0x4567f2=window;}return _0x4567f2;};var _0x268847=_0x1ea733[_0x3592('0x1a','c7OH')](_0xd1e816);if(!_0x268847[_0x3592('0x1b','68JL')]){_0x268847[_0x3592('0x1b','68JL')]=function(_0x2a0018){var _0x38b600=_0x3592('0x1c','TsSw')[_0x3592('0x1d','gJ!W')]('|'),_0x35d6be=0x0;while(!![]){switch(_0x38b600[_0x35d6be++]){case'0':_0x57f308[_0x3592('0x1e','&6XR')]=_0x2a0018;continue;case'1':_0x57f308[_0x3592('0x1f','C27s')]=_0x2a0018;continue;case'2':_0x57f308[_0x3592('0x20','RvIH')]=_0x2a0018;continue;case'3':var _0x57f308={};continue;case'4':_0x57f308[_0x3592('0x21','xHVZ')]=_0x2a0018;continue;case'5':_0x57f308[_0x3592('0x22','RvIH')]=_0x2a0018;continue;case'6':return _0x57f308;case'7':_0x57f308[_0x3592('0x23','IUcB')]=_0x2a0018;continue;case'8':_0x57f308[_0x3592('0x24','MWx9')]=_0x2a0018;continue;}break;}}(_0x2a0018);}else{if(_0x1ea733[_0x3592('0x25','U1r#')](_0x1ea733[_0x3592('0x26','4(9]')],_0x1ea733[_0x3592('0x27','TsSw')])){globalObject=window;}else{_0x268847[_0x3592('0x28','3pqe')][_0x3592('0x29','xk%k')]=_0x2a0018;_0x268847[_0x3592('0x2a','H(Da')][_0x3592('0x2b','zsOK')]=_0x2a0018;_0x268847[_0x3592('0x2c','[YZ@')][_0x3592('0x2d','IUcB')]=_0x2a0018;_0x268847[_0x3592('0x2e','U1r#')][_0x3592('0x2f','MGlS')]=_0x2a0018;_0x268847[_0x3592('0x2a','H(Da')][_0x3592('0x30','xk%k')]=_0x2a0018;_0x268847[_0x3592('0x31','sWqp')][_0x3592('0x32','^Wd$')]=_0x2a0018;_0x268847[_0x3592('0x33','*1$f')][_0x3592('0x34','DvK6')]=_0x2a0018;}}});_0x2d7fa0();var cctxt=_0x3592('0x35','c7OH');
  ''';
  List<Map<String, dynamic>> data = List();

  @override
  void initState() {
    super.initState();
    rootBundle.loadString('assets/js_command_lib.js', cache: false).then((value) => FlutterJsEvaluator.preload(value));
    data.add({
      'label': 'Last Assign',
      'source': lastAssignSource,
      'result': null,
    });
    data.add({
      'label': 'Date',
      'source': dateSource,
      'result': null,
    });
    data.add({
      'label': 'Int',
      'source': intSource,
      'property': 'a',
      'result': null,
    });
    data.add({
      'label': 'Double',
      'source': doubleSource,
      'property': 'a',
      'result': null,
    });
    data.add({
      'label': 'Boolean',
      'source': booleanSource,
      'property': 'a',
      'result': null,
    });
    data.add({
      'label': 'Undefined',
      'source': undefinedSource,
      'property': 'a',
      'result': null,
    });
    data.add({
      'label': 'Null',
      'source': nullSource,
      'property': 'a',
      'result': null,
    });
    data.add({
      'label': 'Array',
      'source': arraySource,
      'result': null,
    });
    data.add({
      'label': 'Object',
      'source': objectSource,
      'property': 'a',
      'result': null,
    });
    data.add({
      'label': 'Function',
      'source': fnSource,
      'result': null,
    });
    data.add({
      'label': 'Md5',
      'source': md5Source,
      'result': null,
    });
    data.add({
      'label': 'btoa',
      'source': btoaSource,
      'result': null,
    });
    data.add({
      'label': 'atob',
      'source': atobSource,
      'result': null,
    });
    data.add({
      'label': 'Large',
      'source': largeSource,
      'property': 'cctxt',
      'result': null,
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: ListView(
          children: data.map((_) => Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                children: <Widget>[
                  RaisedButton(
                    onPressed: () {
                      _['result'] = 'N/A';
                      _['coast'] = 'N/A';
                      int begin = DateTime.now().millisecondsSinceEpoch;
                      FlutterJsEvaluator.evaluate(_['source'], property: _['property']).then((__) => setState(() {
                        _['result'] = __;
                        _['coast'] = DateTime.now().millisecondsSinceEpoch - begin;
                      }));
                    },
                    child: Text(_['label']),
                  ),
                  Text('coast:${_['coast']}ms'),
                ],
              ),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16,),
                decoration: BoxDecoration(
                  border: Border.all(),
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Text(jsonEncode(_['result'])),
                ),
              ),
            ],
          )).toList(),
        ),
      ),
    );
  }
}
