#!/usr/bin/env ruby
require 'json'

class Report
    attr_accessor :code, :guest, :entity, :type, :created_at, :updated_at

    def read fname="shops.json"
        open(fname).read
    end

    def parse json
        JSON.parse(json)
    end

    def save
        File.open("result", 'a') { |file|
            file.write(
                "#{@code}. Guest: #{@guest}. #{@type} #{@entity} at #{@updated_at}\n"
            )
        }
    end

    def send result_file, to="email"
        report = self.read result_file

        case to
        when "email"
            Mailer.deliver(
              from: 'system@email.com', 
              to: host.email, 
              subject: 'Report',
              body: report
            )
        when "telegram"
            #
        end
    end

    def to_s
        "#{@code}. Guest: #{@guest}. #{@type} #{@entity} at #{@updated_at}"
    end
        
end

r = Report.new
parsed = r.parse(r.read)

parsed.each do |object|
    r.code =  object["code"]
    r.guest = object["guest"]
    r.entity =  object["entity"]
    r.type = object["type"].capitalize
    r.created_at = object["created_at"]
    r.updated_at = object["updated_at"]
    r.save
end

r.send("result", "email")
