class TimesheetPdf < Prawn::Document
  def initialize
    super

    text "Hey there"

    stroke_bounds
    stroke_circle [0, 0], 10
    bounding_box([100, 300], :width => 300, :height => 200) do
      stroke_bounds
      stroke_circle [0, 0], 10
    end
  end
end