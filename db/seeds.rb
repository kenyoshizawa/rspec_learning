# db/seeds/ ディレクトリ内のシードファイルについて、読み込み順序を指定して実行する
ORDERED_SEED_FILES = [
  'users.rb',
  'projects.rb',
  'notes.rb'
].freeze

SEEDS_DIR = Rails.root.join('db/seeds')

ORDERED_SEED_FILES.each do |file_name|
  seed_file_path = SEEDS_DIR.join(file_name)

  if File.exist?(seed_file_path)
    puts "#{file_name} を読み込みます"
    begin
      load seed_file_path
      puts "#{file_name} の読み込みが完了しました"
    rescue ScriptError, StandardError => e
      puts "エラークラス：#{e.class}"
      puts "エラーメッセージ：#{e.message}"
      raise "[ERROR] #{file_name} の読み込みでエラーが発生したため、処理を停止しました"
    end
  else
    raise "[ERROR] シードファイルが存在しません: #{seed_file_path}"
  end
end

puts "初期データの投入が正常に完了しました"
