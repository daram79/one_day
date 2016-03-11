module ConvenienceItemsHelper
  def get_conveni_name(conveni_name)
    if conveni_name == "gs25"
      return "GS25"
    elsif conveni_name == "cu"
      return "CU"
    elsif conveni_name == "mini_stop"
      return "미니스탑"
    elsif conveni_name == "seven_eleven"
      return "세븐일레븐"
    end
  end
end
