class CommandsController < ApplicationController
  require 'open3'
  def index
    @message = "Hello,Check Your processes"
  end

  def show
  end

  def sidekiq_status
    cmd ="ps aux | grep '[s]idekiq'"
  
    Open3.popen3(cmd) do |stdin, stdout, stderr, wait_thr|
      @sidekiq_status = stdout.read.to_s
      p "==========="
      p @sidekiq_status
      p "++++++++++++++++"
      if @sidekiq_status.blank?
        @status = "No Sidekiq Process running"
        p @status 
      else
        @status = @sidekiq_status
      end
      # render commands_sidekiq_status_url, :notice => status
    end
    @status
  end

  def stop_sidekiq
    cmd = "cd #{Rails.root} && ps -ef | grep sidekiq | grep -v grep | awk '{print $2}' | xargs kill -9"
                      
    sleep 2

    Open3.popen3(cmd) do |stdin, stdout, stderr, wait_thr|
      @status = stdout.read.to_s
    end
    redirect_to(commands_sidekiq_status_url)
  end


  def start_sidekiq
    cmd = "cd #{Rails.root} && bundle exec sidekiq -d -L #{Rails.root}/log/sidekiq_development.log"
    sleep 2
    Open3.popen3(cmd) do |stdin, stdout, stderr, wait_thr|
      while line = stdout.gets
        puts line
      end
      @status=stdout.gets.to_s
      # redirect_to root_url, :notice=>status
    end
    #p @status
    redirect_to(commands_sidekiq_status_url)
  end

  def nginx_status
    cmd="cd #{Rails.root} && sudo service nginx status"
  
    Open3.popen3(cmd) do |stdin, stdout, stderr, wait_thr|
      @status = stdout.read.to_s
      # redirect_to root_url, :notice=>status
    end
    @status
  end


  def stop_nginx
    cmd = "cd #{Rails.root} && sudo service nginx stop"
    sleep 2
    Open3.popen3(cmd) do |stdin, stdout, stderr, wait_thr|
      @status = stdout.read.to_s
      #  redirect_to root_url, :notice=>status
    end
    @status
  end

  def start_nginx
    cmd="cd #{Rails.root} && sudo service nginx start"
    sleep 2
    Open3.popen3(cmd) do |stdin, stdout, stderr, wait_thr|
      sleep 2
      @status = stdout.read.to_s
      # redirect_to root_url, :notice=>status
    end
    @status
  end

  def restart_nginx
    cmd="cd #{Rails.root} && sudo service nginx restart"
    Open3.popen3(cmd) do |stdin, stdout, stderr, wait_thr|
      sleep 2
      @status = stdout.read.to_s
      #redirect_to root_url, :notice=>status
    end
    @status
  end


  def start_solr
    cmd = "cd #{Rails.root} &&  bundle exec rake sunspot:solr:start"
    sleep 2
    Open3.popen3(cmd) do |stdin, stdout, stderr, wait_thr|
      sleep 2
      @status = stdout.read.to_s
      #redirect_to root_url, :notice=>status
    end
    redirect_to(commands_solr_status_url)
  end

  def stop_solr
    cmd = "ps -ef | grep solr | grep -v grep | awk '{print $2}' | xargs kill -9"
    sleep 2
    Open3.popen3(cmd) do |stdin, stdout, stderr, wait_thr|
      sleep 2
      @status = stdout.read.to_s
      #  redirect_to root_url, :notice=>status
    end
    redirect_to(commands_solr_status_url)
  end

  def restart_solr
    cmd = "cd #{Rails.root} &&  bundle exec rake sunspot:solr:reindex"
    sleep 2
    Open3.popen3(cmd) do |stdin, stdout, stderr, wait_thr|
      sleep 2
      @status = stdout.read.to_s
      # redirect_to root_url, :notice=>status
    end
    redirect_to(commands_solr_status_url)
  end

  def solr_status
    cmd="ps -ef | grep solr "
    sleep 1
    Open3.popen3(cmd) do |stdin, stdout, stderr, wait_thr|
      sleep 2
      @status_out = stdout.read.to_s
      p @status_out
      if @status_out.blank?
        @status = "No  Solr Process running"
      else
        @status = @status_out
      end
      #redirect_to root_url, :notice=>status
    end
    @status
  end

  def redis_status
    cmd="cd #{Rails.root} &&  ps -ef | grep redis"
    Open3.popen3(cmd) do |stdin, stdout, stderr, wait_thr|
      @status = stdout.read.to_s
      # redirect_to root_url, :notice=>status
      p "+++++"
      p @status
      p "==============="
      if @status.include?(":6379")
        @status = "Redis Server is running"
      else
        @status = "Redis server has stopped, Go and start the Redis-Server"
      end
    end
    @status
  end

  def start_redis
    cmd="cd #{Rails.root} && redis-server"
    Open3.popen3(cmd) do |stdin, stdout, stderr, wait_thr|
      sleep 2
      @status = stdout.read.to_s
      # redirect_to root_url, :notice=>status
    end
    redirect_to(commands_redis_status_url)
  end

  def stop_redis
    cmd='redis-cli shutdown'
    sleep 1
    Open3.popen3(cmd) do |stdin, stdout, stderr, wait_thr|
      sleep 2
      @status = stdout.read.to_s
      #  redirect_to root_url, :notice=>status
    end
    redirect_to(commands_redis_status_url)
  end

  def cpu_consumed_mem
    #cmd= "free | grep Mem | awk '{print $3/$2 * 100.0}'"
    cmd ="df -lh |awk '{ print $2}' | head -2 | cut -d'%' -f1"
    cmd1 ="df -lm | awk '{ print $3 = $3/1024 }' | tail -5|head -1| cut -d'%' -f1"
    cmd2 ="df -lm | awk '{ print $4 = ($2-$3)/1024 }' |tail -5|head -1 |cut -d'%' -f1"
    cmd3 ="df -lm | awk '{ print $5}' | head -2 | cut -d'%' -f1"
    Open3.popen3(cmd) do |stdin, stdout, stderr, wait_thr|
      @status = stdout.read.to_s
      # redirect_to root_url, :notice=>status
    end
    @status
    Open3.popen3(cmd1) do |stdin, stdout, stderr, wait_thr|
      @status1 = stdout.read.to_s
    
    end
    Open3.popen3(cmd2) do |stdin, stdout, stderr, wait_thr|
      @status2 = stdout.read.to_s
    end
     Open3.popen3(cmd3) do |stdin, stdout, stderr, wait_thr|
      @status3 = stdout.read.to_s
    end

  end

  def free_memory
    cmd= "free | grep Mem | awk '{print $4/$2 * 100.0}'"
    Open3.popen3(cmd) do |stdin, stdout, stderr, wait_thr|
      @status = stdout.read.to_s
      # redirect_to root_url, :notice=>status
    end
    @status
  end

  def detail_memory
  cmd= "free -m | grep Mem | awk '{print $2 = $2/1024}'"
  cmd1="free -m | grep Mem | awk '{print $3 = $3/1024}'"
  cmd2="free -m | grep Mem | awk '{print $4 = $4/1024}'"
  Open3.popen3(cmd) do |stdin,stdout,stderr,wait_thr|
    @status =stdout.read.to_s

  end
   Open3.popen3(cmd1) do |stdin,stdout,stderr,wait_thr|
    @status1 = stdout.read.to_s
  end
   Open3.popen3(cmd2) do |stdin,stdout,stderr,wait_thr|
    @status2 = stdout.read.to_s
  end
 end

  def sys_ip
    cmd="cd #{Rails.root} && ip route get 8.8.8.8 | awk '{print $NF; exit}'"
    Open3.popen3(cmd) do |stdin, stdout, stderr, wait_thr|
      @ip = stdout.read.to_s
    end
    @ip
  end

  def pass_status
    cmd="cd #{Rails.root} && ps -ef | grep passenger"
    Open3.popen3(cmd) do |stdin, stdout, stderr, wait_thr|
      @status = stdout.read.to_s
    end
   # @status
  end

  def pass_restart
    cmd="cd #{Rails.root} && touch tmp/restart.txt"
    Open3.popen3(cmd) do |stdin, stdout, stderr, wait_thr|
      @status = stdout.read.to_s
    end
    @status
  end



end
