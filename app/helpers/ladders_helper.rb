module LaddersHelper
  def next_page?
    Ladder.next_page?(id: params[:id], page: params[:page])
  end

  def prev_page?
    Ladder.prev_page?(id: params[:id], page: params[:page])
  end
end
