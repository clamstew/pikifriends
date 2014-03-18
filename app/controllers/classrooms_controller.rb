class ClassroomsController < ApplicationController
  def blogs_before_proofread
    @classroom = Classroom.find(params[:id])
    pp @classroom
  end
end
