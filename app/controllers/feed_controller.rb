require 'csv'
class FeedController < ApplicationController
  
  def students_actionsdata_with_class
    @classroom = Classroom.find(params[:id])
    CSV::Writer.generate(output = "") do |csv|
      csv << ['Name', 'Since', 'Blogs', 'Blog Comments', 'Images', 'Image Comments', 'Messages', 'About Me']
      Classroom.find(params[:id]).users.find(:all, :order => 'lastname, firstname').each do |user|
        name = user.lastname.to_s + ', ' + user.firstname.to_s
        if user.about.length > 0
          aboutme = 'YES'
        else
          aboutme = 'NO'
        end
        csv << [name, user.created_at, user.blogs.count, user.get_blog_comments_count(), user.pictures.count, user.get_image_comments_count(), user.get_messages_count(), aboutme]
      end
    end
    send_data(output, :type=>'text/csv', :filename=>@classroom.grade.name+'_'+@classroom.name+'_students_actionsdata.csv')
    
  end
  
  def students_statusdata_with_class
    @classroom = Classroom.find(params[:id])
    CSV::Writer.generate(output = "") do |csv|
      csv << ['Name', 'Since', 'Username', 'Password', 'Log in', 'Friends']
      Classroom.find(params[:id]).users.find(:all, :order => 'lastname, firstname').each do |user|
        name = user.lastname.to_s + ', ' + user.firstname.to_s
        csv << [name, user.created_at, user.username, user.password, user.login, user.friendships.count]
      end
    end
    send_data(output, :type=>'text/csv', :filename=>@classroom.grade.name+'_'+@classroom.name+'_students_statusdata.csv')
    
  end
  
end
