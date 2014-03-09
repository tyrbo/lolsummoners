module LaddersHelper
  def next_page?
    Ladder.next_page?(region: params[:region], page: params[:page])
  end

  def prev_page?
    Ladder.prev_page?(region: params[:region], page: params[:page])
  end
end
