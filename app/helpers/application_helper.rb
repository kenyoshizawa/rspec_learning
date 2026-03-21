module ApplicationHelper
  JUST_NOW_THRESHOLD = 60

  def full_date(date)
    return "-" if date.blank?

    date_string = l(date, format: :long)

    # 現在時刻との差が1分未満の場合「1分未満前」のような不自然な表現を避け「たった今」と表示する
    # 例："2026年01月16日 (たった今)"
    diff_seconds = (Time.current - date.in_time_zone).to_i.abs
    if diff_seconds < JUST_NOW_THRESHOLD
      return t("helpers.full_date.just_now", date: date_string)
    end

    # それ以外の場合は、相対時間を計算し、日付データと組み合わせて返す
    # 例："2026年01月16日 (2日前)"
    date_human = time_ago_in_words(date)
    past_or_future = Time.current > date ? "past" : "future"
    t("helpers.full_date.#{past_or_future}", date: date_string, time: date_human)
  end
end
