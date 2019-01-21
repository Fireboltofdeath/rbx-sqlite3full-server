local sql = {
	ApiUrl = "http://scrumptiliously-delishously-pepisohously.glitch.me", -- Do not use a trailing slash.
	Token = "USE A PASSWORD GENERATOR",
}
local http = game:GetService'HttpService';
local dummyFunction = function()end;

function sql:Query(query)
	local statement = {};
	function statement:Bind(...)
		statement._bind = {};
		local param = {...};
		for i,v in pairs(param) do
			if (typeof(v) ~= "string") then
				return error("statement.Bind: value must be string");
			else
				table.insert(statement._bind, v);
			end
		end
	end
	
	function statement:Run(...)
		if (select("#", ...) > 0) then statement:Bind(...) end
		local data = http:RequestAsync({
			Url = sql.ApiUrl .. "/run",
			Method = "POST",
			Headers = {
				ApiToken = sql.Token,
				["Content-Type"] = "application/json"
			},
			Body = http:JSONEncode{
				query = query,
				bindparam = statement._bind
			}
		})
		local validJson, Resp = pcall(function()
			return http:JSONDecode(data.Body);
		end)
		if (validJson) then
			if (data.StatusCode == 200) then
				return true, {
					Success = true,
					ServerResponse = Resp
				}
			else
				if (Resp.error == nil) then
					return false, {
						Success = false,
						Message = "Request failed. [" .. data.StatusCode .. "]",
						ServerResponse = Resp
					}
				else
					return false, {
						Success = false,
						Message = "SQL Query failed.",
						Error = Resp.error
					}
				end
			end
		else
			return false, {
				Success = false,
				Message = "Server returned invalid response"
			}
		end
	end
	
	function statement:Get(...)
		if (select("#", ...) > 0) then statement:Bind(...) end
		local data = http:RequestAsync({
			Url = sql.ApiUrl .. "/get",
			Method = "POST",
			Headers = {
				ApiToken = sql.Token,
				["Content-Type"] = "application/json"
			},
			Body = http:JSONEncode{
				query = query,
				bindparam = statement._bind
			}
		})
		local validJson, Resp = pcall(function()
			return http:JSONDecode(data.Body);
		end)
		if (validJson) then
			if (data.StatusCode == 200) then
				return true, Resp.response, {
					Success = true,
					ServerResponse = Resp
				}
			else
				if (Resp.error == nil) then
					return false, {
						Success = false,
						Message = "Request failed. [" .. data.StatusCode .. "]",
						ServerResponse = Resp
					}
				else
					return false, {
						Success = false,
						Message = "SQL Query failed.",
						Error = Resp.error
					}
				end
			end
		else
			return false, {
				Success = false,
				Message = "Server returned invalid response"
			}
		end
	end
	
	return statement;
end


return sql;
