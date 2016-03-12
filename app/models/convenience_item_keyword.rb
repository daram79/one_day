#encoding: utf-8
require 'csv'   # csv操作を可能にするライブラリ
require 'kconv' # 文字コード操作をおこなうライブラリ
class ConvenienceItemKeyword < ActiveRecord::Base
  belongs_to :convenience_master
  
  def self.import_csv(csv_file)
    csv_text = csv_file.read
    data = []
    #文字列をUTF-8に変換
    CSV.parse(Kconv.toutf8(csv_text)) do |row|
      i = 1
      flg = false
      next if row[i] == "" || row[i] == nil
      master_datas = ConvenienceMaster.where(item_name: row[i])
      if master_datas.size < 0
        #데이터 없음. error
      elsif master_datas.size > 1
        #마스터 데이터 2개이상 error
      elsif master_datas.size == 1
        flg = true
      end
      
      while flg
        i += 1
        break if row[i] == "" || row[i] == nil
        chk_datas = ConvenienceItemKeyword.where(convenience_master_id: master_datas[0].id, keyword: row[i])
        if chk_datas.blank?
          # p "#{master_datas[0].id}, #{master_datas[0].item_name}: #{row[i]}"
          ConvenienceItemKeyword.create(convenience_master_id: master_datas[0].id, keyword: row[i])
        end
      end
    end
  end
end
