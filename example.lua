local SQL = require(script.Parent.SQL);
SQL:Query("CREATE TABLE IF NOT EXISTS supertest (id INT PRIMARY KEY, value VARCHAR(150), anothervalue VARCHAR(200), anotherint INT)"):Run();

local userInput = "I'm a user and I typed this"
local stmt = SQL:Query("INSERT INTO supertest (id, value, anothervalue, anotherint) VALUES (?, ?, ?, ?)");
stmt:Bind("35", "Super Value!", userInput, 202);
stmt:Run();

local values = SQL:Query("SELECT * FROM supertest WHERE id=?"):Get("35");
for i,v in pairs(values) do
  print(i)
  table.foreach(v, print);
end
-- This is untested.
