class ProfilesController < ApplicationController
   def index
    @user = User.find(1)
    raise Forbidden unless user_safe?

    @skill_categories = user_reccomend_skill_categories
    # ユーザーに紐づく記事をすべて取得
    # 関連テーブルでの絞り込みがないため、LEFT OUTER JOIN句を使わないpreloadを使用
    @articles = @user.articles.preload(:tags)
  end

  private

  def user_safe?
    @user.user_cautions.all? do |user_caution|
      Time.zone.now > user_caution.caution_freeze.end_time
    end
  end

  def user_reccomend_skill_categories
    @user.skills.map(&:skill_category).
      filter { |skill_category| skill_category.reccomend }.uniq
  end
end
