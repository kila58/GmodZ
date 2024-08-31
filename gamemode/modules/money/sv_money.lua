---------------------------
--------DROP MONEY---------
---------------------------
hook.Add("PlayerSay", "dosh", function(ply, text, isteam)

	text = string.lower(text)

	if (string.sub(text, 0, 3) == "!dm") then

		textshit = string.Explode(" ", text)

		local moneyamount = textshit[2] --Get the string

		local reelmoni = tonumber(moneyamount) --Convert to a number

		local rounded = math.Round( reelmoni ) --Round it out

		local dosh = ents.Create("gmodz_dollar")

		dosh:SetPos(ply:GetPos() + Vector( 0, 0, 5 ))

		if (ply:GetMoney() < rounded) or (rounded == nil) or rounded < 1 or !ply:Alive() then

			ply:ChatPrint("[ERROR] Input is not valid") --Basic anti-exploit checks

			return

		else

			dosh:Spawn()

			dosh.amount = rounded

			ply:AddMoney(-dosh.amount)

			ply:ChatPrint("Dropped: $".. dosh.amount)

		end

		return "" --No one can see what we typed

	end

end)