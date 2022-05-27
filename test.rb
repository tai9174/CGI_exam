require 'webrick'
# require 'webrick'ですが、gem install webrickでインストールされたライブラリ「webrick」
# を呼び出しています。こうすることで、このRubyファイル内でWebrickが使えるようになります。
server = WEBrick::HTTPServer.new({
#WEBrick::HTTPServer.newでWebrickのインスタンスを作成し、
# serverという名前のローカル変数に入れます。 ⇨＊１
  :DocumentRoot => '.',
  :CGIInterpreter => WEBrick::HTTPServlet::CGIHandler::Ruby,
  :Port => '3000',
})
# ＊１その初期値として、　DocumentRoot：このWebアプリケーションのドメインの設定
# （ここに書き込まれた記述が、作成するWebアプリケーションのドメインになる）
# CGIInterpreter：このプログラムを実行（翻訳）できるプログラム（Rubyのこと）本体の居場所を指定する記述。
# Port：このWebアプリケーションの情報の出入り口を表す設定。
# の三つを設定する必要がある。
# ▲ドメイン・IPアドレス・ポートなどの設定がWebアプリケーションには必要であり、
# 今回のプログラムでは使用するRubyの場所を指定する必要がある
['INT', 'TERM'].each {|signal|
  Signal.trap(signal){ server.shutdown }
}

server.mount('/', WEBrick::HTTPServlet::ERBHandler, 'goya.html.erb')
server.mount('/test', WEBrick::HTTPServlet::ERBHandler, 'test.html.erb')
# ↑はWebサーバを起動した状態で、（DocumentRootの値）/testというURLを送信すると、
# 同じディレクトリ階層にあるtest.html.erbファイルを表示するという機能が付与されます。
# 今回のDocumentRootは’.’ですから、”./test”というURLが送信されることになります。
# この一行を追記
server.mount('/indicate.cgi', WEBrick::HTTPServlet::CGIHandler, 'indicate.rb')
# server.mount('/indicate.cgi', WEBrick::HTTPServlet::CGIHandler, 'indicate.rb')
# の行を追加することで、<form action='indicate.cgi'> 〜 </form>の内部にある値を、
# indicate.rbに送信することができる

server.mount('/goya.cgi', WEBrick::HTTPServlet::CGIHandler, 'goya.rb')
# goyaDBの情報を出力するためのgoya.rbファイルを作成しましょう。
server.mount('/goya_sell.cgi', WEBrick::HTTPServlet::CGIHandler, 'goya_sell.rb')
server.mount('/goya_false.cgi', WEBrick::HTTPServlet::CGIHandler, 'goya_false.rb')
server.start
# Webrickのサーバを起動させる、という意味のコードです。

# 補足１　Index of/ は　Webサーバが、「/」、というURLで取得できるリソース
# （HTMLのページなど）を探したけれど、何も見つからなかった状態です。
# 代わりに今アクセスしているディレクトリにあるファイル一覧が表示されています。

# 補足２　現在のRubyファイルに記述されているWebrickのURL取得の設定はserver.mount
# ('/test', WEBrick::HTTPServlet::ERBHandler, 'test.html.erb')のみ
# となっており、/に対する設定がされていないので、このような画面が出てしまいます。
# つづいてURLの末尾に、/testを追加して、再読み込みしてみましょう。
# すると、下記画像のように自分が作成したHTMLページが表示するはずです。
# Webrickで作成されたWebサーバが、/test というリクエストを受け取って、
# そこから自分の作成したHTMLページを見つけ、そのページを表示した

# 補足３　全体の逃れ。
# test.rbのファイルを実行することで、Webrickが読み込まれ、Webサーバが起動する
# ↓
# その状態で ~/test のURLを叩くと、test.html.erbのページを、Webサーバから取得・表示できるようになる
# ↓
# test.html.erbに書かれている送信ボタンを押すと、form action='indicate.cgi'に処理が飛ぶ
# ↓
# すると、server.mount('/indicate.cgi', （〜省略〜） ,'indicate.rb')が処理を受け取る
# ↓
# indicate.rbの処理が実行され、値を反映したhtmlが返却されて、ブラウザに表示される

# 補足４　最後のおさらい　このように「ユーザーのアクションによって、出力する情報が変化する」
# のが、基本的なWebアプリケーションの形です。

# Webサーバを起動させ、特定のURLのリクエストが飛んで来たら、レスポンスを返せるように設定しておく
# HTML、CSS、JavaScriptで、情報を入力してもらうようなページを作成する
# そのページから、送られてきた入力情報をWebサーバが受け取る
# Rubyなどのサーバーサイドプログラミング言語が、その情報を処理・加工する
# 必要があれば、情報をDBに保存したり、もしくはDBから情報を取り出すなどの処理をする
# （主にSQL言語を用いる）
