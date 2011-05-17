class CreateCdr < ActiveRecord::Migration
  def self.up
    create_table :cdr, :force => true do |t|
      t.datetime :calldate,    :null => false, :default => 'now()'
      t.string   :clid,        :limit => 80,  :null => false, :default => ''
      t.string   :src,         :limit => 80,  :null => false, :default => ''
      t.string   :dst,         :limit => 80,  :null => false, :default => ''
      t.string   :dcontext,    :limit => 80,  :null => false, :default => ''
      t.string   :channel,     :limit => 80,  :null => false, :default => ''
      t.string   :dstchannel,  :limit => 80,  :null => false, :default => ''
      t.string   :lastapp,     :limit => 80,  :null => false, :default => ''
      t.string   :lastdata,    :limit => 80,  :null => false, :default => ''
      t.column   :duration,    'bigint NOT NULL default \'0\''
      t.column   :billsec,     'bigint NOT NULL default \'0\''
      t.string   :disposition, :limit => 45,  :null => false, :default => ''
      t.column   :amaflags,    'bigint NOT NULL default \'0\''
      t.column   :accountcode, 'bigint NOT NULL default \'0\''
      t.string   :uniqueid,    :limit => 32,  :null => false, :default => ''
      t.string   :userfield,   :limit => 255, :null => false, :default => ''
      t.boolean  :billed,      :null => false, :default => false
    end
    # cdr table:
    #
    # ActiveRecord::Base.connection.execute("
    #   CREATE TABLE cdr (
    #     calldate timestamp with time zone NOT NULL default now(),
    #     clid varchar(80) NOT NULL default '', 
    #     src varchar(80) NOT NULL default '', 
    #     dst varchar(80) NOT NULL default '', 
    #     dcontext varchar(80) NOT NULL default '', 
    #     channel varchar(80) NOT NULL default '', 
    #     dstchannel varchar(80) NOT NULL default '', 
    #     lastapp varchar(80) NOT NULL default '', 
    #     lastdata varchar(80) NOT NULL default '', 
    #     duration bigint NOT NULL default '0', 
    #     billsec bigint NOT NULL default '0', 
    #     disposition varchar(45) NOT NULL default '', 
    #     amaflags bigint NOT NULL default '0', 
    #     accountcode varchar(20) NOT NULL default 0, 
    #     uniqueid varchar(32) NOT NULL default '', 
    #     userfield varchar(255) NOT NULL default '' 
    #   );
    # ");
  end

  def self.down
    drop_table :cdr
  end
end
