module UserHelper
  def format_phone(phone)
    Phonelib.parse(phone).national
  end
end
