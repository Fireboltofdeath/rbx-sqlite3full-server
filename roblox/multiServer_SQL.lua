local sql = {
	ApiUrl = "https://scrumptiliously-delishously-horshoushly.glitch.me", -- No trailing slashes
}
local http = game:GetService'HttpService';
local dummyFunction = function()end;
function sql:CreateDatabase(Path, ApiToken)
	if (not (Path and ApiToken)) then return error("Argument missing or nil"); end
	if (Path:sub(1,1) ~= "/") then Path = "/" .. Path end;
	
	local ApiUrl = sql.ApiUrl .. Path;
	local sql2 = {};
	function sql2:Query(query)
		local statement = {};
		function statement:Bind(...)
			statement._bind = {};
			local param = {...};
			for i,v in pairs(param) do
				table.insert(statement._bind, v);
			end
		end
		
		function statement:Run(...)
			if (select("#", ...) > 0) then statement:Bind(...) end
			local data = http:RequestAsync({
				Url = ApiUrl .. "/run",
				Method = "POST",
				Headers = {
					ApiToken = ApiToken,
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
				Url = ApiUrl .. "/get",
				Method = "POST",
				Headers = {
					ApiToken = ApiToken,
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
					Message = "Server returned invalid response",
					Body = data.Body
				}
			end
		end
		
		return statement;
	end
	return sql2;
end

return sql;
