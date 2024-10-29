class Api::V1::PostsController < ApplicationController
  def index # 投稿しているブログをすべて取得したい時にindexにアクセス
    @posts = Post.all # modelの名前がpostだからpostの全てという意味になる
    render json: @posts # フロントでも扱えるように@postsというインスタンス変数がjson形式にする
  end

  def show # 記事の詳細ページ
    @post = Post.find(params[:id]) # 今見ているブログのidの情報を@postに入れることができる
    render json: @post
  end

  def create # ブログ投稿をするときはtitleとcontentをリクエストのbodyに含めるとできる
    @post = Post.new(post_params) # post_paramsはストロングパラメータ

    if @post.save # 作成したポストが保存できたら
      render json: @post,  status: :created # これで201番のステータスが返ってくる
    else
      render json: @post.errors, status: :unprocessable_entity # これで422番のエラーが返ってくる
    end
  end

  def update
    @post = Post.find(params[:id]) # どの投稿を編集するかのidを取得する必要がある

    if @post.update(post_params) # post_paramsのデータを含んだ更新が完了したら
      render json: @post
    else
      render json: @post.errors, status: :unprocessable_entity # これで422番のエラーが返ってくる
    end
  end

  def destroy
    @post = Post.find(params[:id]) # どの投稿を削除するかのidを取得する必要がある

    @post.destroy
  end

  private # 今から書く関数やメソッドはこのファイルでしか使用できないという明示

  def post_params # titleとcontent、だけを許可するというパラメータを宣言
    params.require(:post).permit(:title, :content)
  end
end
