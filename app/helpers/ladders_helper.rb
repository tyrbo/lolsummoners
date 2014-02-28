module LaddersHelper
  def has_next_page?
    Ladder.has_next_page?(id: params[:id], page: params[:page])
  end

  def has_prev_page?
    Ladder.has_prev_page?(id: params[:id], page: params[:page])
  end
end
