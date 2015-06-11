#!/usr/bin/env tarantool
pool = require('pool')
os = require('os')
fiber = require('fiber')

local cfg = {
    servers = {
        { 
            uri = 'localhost:33130', login = 'tester', 
            password = 'pass', zone = 'myzone1'
        };
        { 
            uri = 'localhost:33131', login = 'tester', 
            password = 'pass', zone = 'myzone2'
        };
        {
            uri = 'localhost:33132', login = 'tester', 
            password = 'pass', zone = 'myzone3'
        };

    };
}

box.cfg {
    slab_alloc_arena = 0.1;
    wal_mode = 'none';
    listen = 33131;
    custom_proc_title  = "master1"
}

require('console').listen(os.getenv('ADMIN'))

pcall(function()
  box.schema.user.create('tester', { password = 'pass'})
  box.schema.user.grant('tester', 'read,write,execute', 'universe')
end)

-- init
fiber.create(function()
    pool.init(cfg)
end)