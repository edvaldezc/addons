-------------------------------------------------------------------------------------------------------------------
-- Setup functions for this job.  Generally should not be modified.
-------------------------------------------------------------------------------------------------------------------

-- Initialization function for this job file.
function get_sets()
	mote_include_version = 2
	include('organizer-lib')

	-- Load and initialize the include file.
	include('Mote-Include.lua')
end


-- Setup vars that are user-independent.  state.Buff vars initialized here will automatically be tracked.
function job_setup()
	state.Buff.Migawari = buffactive.migawari or false
	state.Buff.Doom = buffactive.doom or false
	state.Buff.Yonin = buffactive.Yonin or false
	state.Buff.Innin = buffactive.Innin or false
	state.Buff.Futae = buffactive.Futae or false

	state.OffenseMode:options('Normal', 'Acc')
	state.HybridMode:options('Normal', 'PDT', 'Crit')
	state.WeaponskillMode:options('Normal', 'Acc', 'Mod')
	state.CastingMode:options('Normal', 'Resistant')
	state.PhysicalDefenseMode:options('PDT', 'Evasion')
	state.MagicBurst = M(false, 'Magic Burst')
	state.TrustMode = M(false, 'Trust Mode')
	state.HasteMode = M{['description'] = 'Haste Mode', '1', '2'}


	state.ProcWeapon:options('None','Katana','Great Katana','Sword','Dagger','Staff','Club','Polearm','Scythe')

	ele_weaponskills = {
		['Katana'] = {'Blade: Ei'},
		['Great Katana'] = {'Tachi: Jinpu', 'Tachi: Koki'},
		['Sword'] = {'Red Lotus Blade', 'Seraph Blade'},
		['Dagger'] = {'Cyclone', 'Energy Drain'},
		['Staff'] = {'Earth Crusher','Sunburst'},
		['Club'] = {'Seraph Strike'},
		['Polearm'] = {'Raiden Thrust'},
		['Scythe'] = {'Shadow of Death'}
}
	proc_weapons = {
		['Katana'] = {'Heishi Shorinken'},
		['Great Katana'] = {'Ark Tachi'},
		['Sword'] = {'Ark Saber'},
		['Dagger'] = {'Atoyac'},
		['Staff'] = {'Treat Staff II'},
		['Club'] = {'Mafic Cudgel'},
		['Polearm'] = {'Pitchfork'},
		['Scythe'] = {'Ark Scythe'}
}
	info.LugraWSs = L{'Blade: Hi','Blade: Shun','Blade: Kamu'}
	organizer_items = {
		heishi="Heishi Shorinken",
		mainkt="Taka",
		selftools="Shikanofuda",
		debufftools="Chonofuda",
		nuketools="Inoshishinofuda",
		-- cpring="Capacity Ring"
		
		}
		
	select_default_macro_book()

	determine_haste_group()

	send_command('bind ^` as on')
	send_command('bind !` as off')
	send_command('bind @` ah')
	send_command('bind ^F1 obox')
	send_command('bind !F1 dbox')
	send_command('bind !F11 input /logout')

end

-- Called when this job file is unloaded (eg: job change)
function user_unload()
	send_command('unbind ^`')
	send_command('unbind !`')
	send_command('unbind @`')
	send_command('unbind ^F1')
	send_command('unbind !F1')
	send_command('unbind !F11')
end

-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Setup vars that are user-dependent.  Can override this function in a sidecar file.


-- Define sets and vars used by this job file.
function init_gear_sets()
	--------------------------------------
	-- Precast sets
	--------------------------------------

	-- Precast sets to enhance JAs
	sets.precast.JA['Mijin Gakure'] = {legs="Mochizuki Hakama"}
	sets.precast.JA['Futae'] = {legs="Iga Tekko +2"}
	sets.precast.JA['Sange'] = {legs="Mochizuki Chainmail"}

	-- Waltz set (chr and vit)
	sets.precast.Waltz = {}
		-- Uk'uxkaj Cap, Daihanshi Habaki
		
	-- Don't need any special gear for Healing Waltz.
	sets.precast.Waltz['Healing Waltz'] = {}

	-- Set for acc on steps, since Yonin drops acc a fair bit
	sets.precast.Step = {
		back="Yokaze Mantle",waist="Chaac Belt"
	}

	sets.precast.Flourish1 = {waist="Chaac Belt"}

	-- Fast cast sets for spells
	
	sets.precast.FC = {ammo="Sapience orb",
		head=gear.herchead_dt,neck="Voltsurge Torque",ear1="Enchanter earring +1",ear2="Loquacious Earring",
		body=gear.fc_tbody,hands="Leyline gloves",ring1="Prolix Ring",ring2="Weatherspoon Ring",
		waist="Ninurta's sash",legs="Arjuna Breeches",feet=gear.hercfeet_fc}
		
	sets.precast.FC.Utsusemi = set_combine(sets.precast.FC, {neck="Magoraga Beads",feet="Hattori Kyahan"})

	-- Snapshot for ranged
	sets.precast.RA = {}
	   
	-- Weaponskill sets
	-- Default set for any weaponskill that isn't any more specifically defined
	sets.precast.WS = {ammo="Yetshila",
		head=gear.adhemarhead_melee,neck="Fotia Gorget",ear1="Telos earring",ear2="Moonshade Earring",
		body="Abnoba Kaftan",hands="Adhemar wristbands",ring1="Rajas Ring",ring2="Petrov Ring",
		back=gear.nincape_wsd,waist="Fotia Belt",legs="Samnuha tights",feet=gear.hercfeet_crit}
	sets.precast.WS.Acc = set_combine(sets.precast.WS, 
		{ammo="Amar Cluster",
		head=gear.adhemarhead_melee,
		body="adhemar jacket",
		back=gear.nincape_wsd,legs="Hattori hakama +1"}) 
	-- Specific weaponskill sets.  Uses the base set if an appropriate WSMod version isn't found.
	sets.precast.WS['Blade: Jin'] = set_combine(sets.precast.WS,
		{ear1="Brutal Earring",ear2="Moonshade Earring",ring1="Ifrit ring +1",ring2="Ifrit ring +1",
		hands="Kobo Kote",
		back="Rancorous Mantle"})
	sets.precast.WS['Blade: Jin'].Acc = set_combine(sets.precast.WS,
		{ear1="Brutal Earring",ear2="Moonshade Earring",
		hands="Kobo Kote",ring1="Ifrit ring +1",ring2="Ifrit ring +1",
		back="Rancorous Mantle"})
	sets.precast.WS['Blade: Hi'] = set_combine(sets.precast.WS,
		{head=gear.adhemarhead_melee,ear1="Ishvara earring",
		body=gear.hercbody_acc,hands=gear.herchands_crit,ring1="Epona's Ring",
		back=gear.nincape_wsd,waist="Windbuffet Belt +1",legs=gear.herclegs_wsd,feet=gear.hercfeet_wsd})
	sets.precast.WS['Blade: Hi'].Acc = set_combine(sets.precast.WS['Blade: Hi'],
		{head="Ryuo somen",
		body="Reiki Osode"})
	sets.precast.WS['Blade: Ten'] = set_combine(sets.precast.WS,
		{body=gear.hercbody_acc,hands=gear.herchands_crit,ring1="Ifrit Ring +1",ring2="Ifrit Ring +1",
		legs="Hiza. Hizayoroi +1",feet=gear.hercfeet_wsd})
	sets.precast.WS['Blade: Kamu'] = set_combine(sets.precast.WS,
		{ammo="Amar Cluster",
		body=gear.hercbody_ta,hands=gear.herchands_acc,ring1="Epona's Ring",ring2="Ifrit Ring +1",
		legs="Hiza. Hizayoroi +1",feet=gear.hercfeet_wsd })
	sets.precast.WS['Blade: Shun'] = set_combine(sets.precast.WS, 
		{ammo="Amar Cluster",
		body=gear.hercbody_acc,hands=gear.herchands_crit,
		feet=gear.hercfeet_crit})


	sets.precast.WS['Aeolian Edge'] = {}

	
	--------------------------------------
	-- Midcast sets
	--------------------------------------

	sets.midcast.FastRecast = {ammo="Sapience Orb",
		head=gear.herchead_mab,neck="Voltsurge torque",ear1="Enchanter earring +1",ear2="Loquacious Earring",
		body=gear.fc_tbody,hands="Leyline gloves",ring1="Prolix Ring",ring2="Weatherspoon Ring",
		back="Grounded mantle +1",waist="Ninurta's sash",legs=gear.fc_tlegs,feet="Amm greaves"}
		
	sets.midcast.Utsusemi = set_combine(sets.midcast.NinjutsuBuff, {back="Andartia's Mantle",feet="Hattori Kyahan"})

	sets.midcast.NinjutsuBuff = set_combine(sets.midcast.FastRecast, {neck="Incanter's torque"})	

	sets.midcast.ElementalNinjutsu = {ammo="Pemphredo tathlum",
		head=gear.fc_thead,neck="Sanctity Necklace",ear1="Friomisi Earring",ear2="Gwati Earring",
		body="Samnuha coat",hands="Leyline gloves",ring1="Shiva Ring +1",ring2="Shiva Ring +1",
		back="Toro Cape",waist="Eschan Stone",legs=gear.herclegs_qd,feet="Hachiya Kyahan"}

	sets.midcast.ElementalNinjutsu.Resistant = set_combine(sets.midcast.ElementalNinjutsu, 
		{ear1="Enchanter earring +1",
		ring2="Weatherspoon Ring",
		back="Yokaze Mantle"})

	sets.midcast.NinjutsuDebuff = set_combine(sets.midcast.ElementalNinjutsu,{
		neck="Incanter's Torque",ear1="Enchanter earring +1",
		ring1="Weatherspoon Ring",ring2="Sangoma Ring",
		waist="Eschan Stone",feet="Hachiya Kyahan"})

	sets.midcast.RA = {}
	-- Hachiya Hakama/Thurandaut Tights +1

	--------------------------------------
	-- Idle/resting/defense/etc sets
	--------------------------------------
	
	-- Resting sets
	sets.resting = {
		ring1="Defending Ring",ring2="Paguroidea Ring"}
	
	-- Idle sets
	sets.idle = {ammo="Amar cluster",
		head="Skormoth Mask",neck="Loricate torque +1",ear1="Impregnable Earring",ear2="Genmei Earring",
		body="Reiki osode",hands="Macabre gauntlets",ring1=gear.DarkRing.PDT,ring2="Defending Ring",
		back="Solemnity Cape",waist="Flume Belt +1",legs="Samnuha tights",feet="Amm greaves"}

	sets.idle.Town = {ammo="Yetshila",
		head="Ryuo somen",neck="Loricate torque +1",ear1="Sanare Earring",ear2="Genmei Earring",
		body="Reiki osode",hands="Leyline gloves",ring1="Defending Ring",ring2=gear.DarkRing.PDT,
		back="Yokaze Mantle",waist="Flume Belt +1",legs="Samnuha tights",feet="Hachiya Kyahan"}
	
	sets.idle.Weak = {}
	
	-- Defense sets
	sets.defense.Evasion = {}
	
	sets.defense.PDT = {ammo="Staunch tathlum",
		head="Genmei kabuto",neck="Loricate torque +1",ear1="Genmei Earring",ear2="Impregnable Earring",
		body="Reiki osode",hands="Macabre gauntlets",ring1="Defending Ring",ring2=gear.DarkRing.PDT,
		back="Solemnity Cape",waist="Flume belt +1",legs="Samnuha tights",feet="Amm greaves"}

	sets.defense.MDT = {ammo="Staunch tathlum",
		head="Skormoth mask",neck="Loricate torque +1",ear1="Genmei Earring",ear2="Sanare Earring",
		body=gear.hercbody_dt,hands=gear.herchands_dt,ring1="Defending Ring",ring2=gear.DarkRing.PDT,
		back="Solemnity Cape",waist="Flume belt +1",legs=gear.herclegs_dt,feet="Ahosi Leggings"}


	sets.Kiting = {ring2="Hachiya Kyahan"}


	--------------------------------------
	-- Engaged sets
	--------------------------------------

	-- Variations for TP weapon and (optional) offense/defense modes.  Code will fall back on previous
	-- sets if more refined versions aren't defined.
	-- If you create a set with both offense and defense modes, the offense mode should be first.
	-- EG: sets.engaged.Dagger.Accuracy.Evasion
	
	-- Normal melee group
	sets.engaged = {ammo="Happo Shuriken",
		head="Ryuo somen",neck="Asperity Necklace",ear1="Suppanomimi",ear2="Brutal Earring",
		body="Adhemar jacket",hands="Floral gauntlets",ring1="Rajas Ring",ring2="Epona's Ring",
		back="Bleating Mantle",waist="Reiki Yotai",legs="Samnuha tights",feet=gear.hercfeet_melee}
	sets.engaged.Acc = {ammo="Happo Shuriken",
		head="Ryuo somen",neck="Lissome Necklace",ear1="Suppanomimi",ear2="Telos Earring",
		body="Adhemar jacket",hands="Floral gauntlets",ring1="Rajas Ring",ring2="Epona's Ring",
		back="Yokaze Mantle",waist="Reiki yotai",legs="Samnuha tights",feet=gear.hercfeet_melee}
	sets.engaged.PDT = {ammo="Happo Shuriken",
		head="Ryuo somen",neck="Agitator's collar",ear1="Impregnable earring",ear2="Genmei Earring",
		body="Adhemar jacket",hands=gear.herchands_melee,ring1="Rajas Ring",ring2="Defending Ring",
		back="Solemnity Cape",waist="Flume belt +1",legs="Samnuha tights",feet="Amm Greaves"}
	sets.engaged.Acc.PDT = {ammo="Happo Shuriken",
		head="Ryuo somen",neck="Combatant's torque",ear1="impregnable earring",ear2="Genmei Earring",
		body="Reiki osode",hands=gear.herchands_melee,ring1="Rajas Ring",ring2="Defending Ring",
		back="Agema cape",waist="Reiki yotai",legs="Samnuha tights",feet=gear.hercfeet_melee}

	--Low haste
	sets.engaged.LowHaste = {ammo="Happo Shuriken",
		head=gear.adhemarhead_melee,neck="Asperity necklace",ear1="Brutal earring",ear2="Telos earring",
		body=gear.hercbody_ta,hands="Adhemar wristbands",ring1="Petrov Ring",ring2="Epona's Ring",
		back="Bleating Mantle",waist="Windbuffet belt +1",legs="Samnuha tights",feet=gear.hercfeet_ta}
	sets.engaged.Acc.LowHaste = {ammo="Happo Shuriken",
		head="Ryuo Somen",neck="Combatant's torque",ear1="Brutal earring",ear2="Telos Earring",
		body="Adhemar jacket",hands=gear.herchands_melee,ring1="Rajas Ring",ring2="Epona's Ring",
		back="Yokaze Mantle",waist="Reiki yotai",legs="Samnuha tights",feet=gear.hercfeet_melee}
	sets.engaged.PDT.LowHaste = {ammo="Happo Shuriken",
		head="Ryuo somen",neck="agitator's collar",ear1="genmei earring",ear2="impregnable Earring",
		body="Adhemar jacket",hands=gear.herchands_melee,ring1="Rajas Ring",ring2="Defending ring",
		back="agema Cape",waist="Flume belt +1",legs="Samnuha tights",feet="Amm Greaves"}
	sets.engaged.Acc.PDT.LowHaste = {ammo="Happo Shuriken",
		head="Ryuo somen",neck="Combatant's torque",ear1="Genmei earring",ear2="Telos Earring",
		body="Adhemar jacket",hands=gear.herchands_melee,ring1="Rajas Ring",ring2="Defending Ring",
		back="Agema cape",waist="Flume belt +1",legs="Samnuha tights",feet=gear.hercfeet_melee}

	-- Custom melee group: High Haste (~20% DW)
	sets.engaged.HighHaste = {ammo="Happo Shuriken",
		head=gear.adhemarhead_melee,neck="Asperity necklace",ear1="Brutal earring",ear2="Telos earring",
		body=gear.hercbody_ta,hands="Adhemar wristbands",ring1="Petrov Ring",ring2="Epona's Ring",
		back="Bleating Mantle",waist="Windbuffet belt +1",legs="Samnuha tights",feet=gear.hercfeet_ta}
	sets.engaged.Acc.HighHaste = {ammo="Happo Shuriken",
		head="Ryuo Somen",neck="Combatant's torque",ear1="Zennaroi earring",ear2="Telos Earring",
		body="Adhemar jacket",hands=gear.herchands_acc,ring1="Rajas Ring",ring2="Epona's Ring",
		back="Grounded Mantle +1",waist="Windbuffet belt +1",legs="Samnuha tights",feet="Hiza. Sune-ate +1"}
	sets.engaged.PDT.HighHaste = {ammo="Happo Shuriken",
		head="Ryuo somen",neck="agitator's collar",ear1="genmei earring",ear2="impregnable Earring",
		body="Adhemar jacket",hands=gear.herchands_melee,ring1="Rajas Ring",ring2="Defending ring",
		back="agema Cape",waist="Flume belt +1",legs="Samnuha tights",feet="Amm Greaves"}
	sets.engaged.Acc.PDT.HighHaste = {ammo="Happo Shuriken",
		head="Ryuo somen",neck="Combatant's torque",ear1="Genmei earring",ear2="Telos Earring",
		body="Adhemar jacket",hands=gear.herchands_melee,ring1="Rajas Ring",ring2="Defending Ring",
		back="Agema cape",waist="Flume belt +1",legs="Samnuha tights",feet=gear.hercfeet_melee}


	-- Custom melee group: Max Haste (0% DW)
	sets.engaged.MaxHaste = {ammo="Happo Shuriken",
		head=gear.adhemarhead_melee,neck="Asperity necklace",ear1="Brutal earring",ear2="Telos earring",
		body=gear.hercbody_ta,hands="Adhemar wristbands",ring1="Petrov Ring",ring2="Epona's Ring",
		back="Bleating Mantle",waist="Windbuffet belt +1",legs="Samnuha tights",feet=gear.hercfeet_ta }
	sets.engaged.Acc.MaxHaste = {ammo="Happo Shuriken",
		head=gear.adhemarhead_melee,neck="Lissome Necklace",ear1="Zennaroi earring",ear2="Telos Earring",
		body="Sayadio's Kaftan",hands="Adhemar wristbands",ring1="Petrov Ring",ring2="Epona's Ring",
		back="Grounded Mantle +1",waist="Olseni Belt",legs="Samnuha tights",feet=gear.hercfeet_ta }
	sets.engaged.PDT.MaxHaste = {ammo="Happo Shuriken",
		head="Ynglinga Sallet",neck="Asperity necklace",ear1="Brutal earring",ear2="Telos earring",
		body=gear.hercbody_dt,hands=gear.herchands_dt,ring1="Defending Ring",ring2="Epona's Ring",
		back="Agema Cape",waist="Windbuffet belt +1",legs="Samnuha tights",feet="Ahosi Leggings"}
	sets.engaged.Acc.PDT.MaxHaste = {ammo="Happo Shuriken",
		head="Ynglinga Sallet",neck="Asperity necklace",ear1="Brutal earring",ear2="Telos earring",
		body=gear.hercbody_dt,hands=gear.herchands_dt,ring1="Defending Ring",ring2="Epona's Ring",
		back="Agema Cape",waist="Windbuffet belt +1",legs="Samnuha tights",feet="Ahosi Leggings" }

	--------------------------------------
	-- Custom buff sets
	--------------------------------------
	sets.WS_earrings = {ear1="Lugra Earring +1",ear2="Lugra Earring"}
	sets.buff.Migawari = {body="Hattori Ningi +1",back=gear.nincape_wsd}
	sets.buff.Doom = {ring2="Saida Ring"}
	sets.buff.Yonin = {legs="Hattori hakama +1"}
	sets.buff.Innin = {}
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------
function job_post_precast(spell, action, spellMap, eventArgs)
	if spell.type == 'WeaponSkill' then
		if info.LugraWSs:contains(spell.english) then
			equip(sets.WS_earrings)
		elseif spell.english == 'Blade: Ten' then
			equip({ear1="Lugra Earring +1"})
		end
	end
end

-- Run after the general midcast() is done.
-- eventArgs is the same one used in job_midcast, in case information needs to be persisted.
function job_post_midcast(spell, action, spellMap, eventArgs)
	if state.Buff.Doom then
		equip(sets.buff.Doom)
	end
end


-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
function job_aftercast(spell, action, spellMap, eventArgs)
	if not spell.interrupted and spell.english == "Migawari: Ichi" then
		state.Buff.Migawari = true
	end
	
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for non-casting events.
-------------------------------------------------------------------------------------------------------------------

-- Called when a player gains or loses a buff.
-- buff == buff gained or lost
-- gain == true if the buff was gained, false if it was lost.
function job_buff_change(buff, gain)
	if S{'haste','march','embrava','mighty guard','Indi-Haste',''}:contains(buff:lower()) then
		determine_haste_group()
		handle_equipping_gear(player.status)
	elseif state.Buff[buff] ~= nil then
		state.Buff[buff] = gain
		handle_equipping_gear(player.status)
	end
end

function job_status_change(new_status, old_status)
	if new_status == 'Idle' then
	end
end


-------------------------------------------------------------------------------------------------------------------
-- User code that supplements standard library decisions.
-------------------------------------------------------------------------------------------------------------------

-- Get custom spell maps
function job_get_spell_map(spell, default_spell_map)
	if spell.skill == "Ninjutsu" then
		if not default_spell_map then
			if spell.target.type == 'SELF' then
				return 'NinjutsuBuff'
			else
				return 'NinjutsuDebuff'
			end
		end
	end
end

-- Modify the default idle set after it was constructed.
function customize_idle_set(idleSet)
	if state.Buff.Migawari then
		idleSet = set_combine(idleSet, sets.buff.Migawari)
	end
	if state.Buff.Doom then
		idleSet = set_combine(idleSet, sets.buff.Doom)
	end
	return idleSet
end


-- Modify the default melee set after it was constructed.
function customize_melee_set(meleeSet)
	if state.Buff.Migawari then
		meleeSet = set_combine(meleeSet, sets.buff.Migawari)
	end
	if state.Buff.Doom then
		meleeSet = set_combine(meleeSet, sets.buff.Doom)
	end
	--[[if state.buff.Yonin then
		meleeSet = set_combine(meleeSet, sets.buff.Yonin)
	end]]
	return meleeSet
end

-- Called by the default 'update' self-command.
function job_update(cmdParams, eventArgs)
	determine_haste_group()
end

function job_state_change(stateField, newValue, oldValue)
	if stateField == 'Proc Weapon Mode' then
		if newValue == 'Katana' then
			equip({main=proc_weapons[state.ProcWeapon.value][1],sub="Taka"})
		elseif newValue == 'None' then
			return
		else
			equip({main=proc_weapons[state.ProcWeapon.value][1]})
			-- print(proc_weapons[state.ProcWeapon.value][1])
		end
	end
	if stateField == 'Haste Mode' then
		determine_haste_group()
	end
end

function job_self_command(cmdParams, eventArgs)
	if cmdParams[1] == 'elews1' then
		elews1()
	elseif cmdParams[1] == 'elews2' then
		elews2()
	end
end
function elews1()
	if state.ProcWeapon.value ~= 'None' then
		send_command('input /'..ele_weaponskills[state.ProcWeapon.value][1]..'')
	end
end
function elews2()
	if state.ProcWeapon.value ~= 'None' then
		if #ele_weaponskills[state.ProcWeapon.value] > 1 then
			send_command('input /'..ele_weaponskills[state.ProcWeapon.value][2]..'')
		else 
			return
		end
	end
end

-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------

	-- We have three groups of DW in gear: Hachiya body/legs, Iga head + Patentia Sash, and DW earrings
	
	-- Standard gear set reaches near capped delay with just Haste (77%-78%, depending on HQs)

	-- For high haste, we want to be able to drop one of the 10% groups.
	-- Basic gear hits capped delay (roughly) with:
	-- 1 March + Haste
	-- 2 March
	-- Haste + Haste Samba
	-- 1 March + Haste Samba
	-- Embrava
	
	-- High haste buffs:
	-- 2x Marches + Haste Samba == 19% DW in gear
	-- 1x March + Haste + Haste Samba == 22% DW in gear
	-- Embrava + Haste or 1x March == 7% DW in gear
	
	-- For max haste (capped magic haste + 25% gear haste), we can drop all DW gear.
	-- Max haste buffs:
	-- Embrava + Haste+March or 2x March
	-- 2x Marches + Haste
	
	-- So we want four tiers:
	-- Normal DW
	-- 20% DW -- High Haste
	-- 7% DW (earrings) - Embrava Haste (specialized situation with embrava and haste, but no marches)
	-- 0 DW - Max Haste
function determine_haste_group()
	classes.CustomMeleeGroups:clear()
	if state.HasteMode.value == '2' then
		if buffactive[680] then 
			if buffactive[33] or buffactive[604] or buffactive[228] or buffactive.march then
				classes.CustomMeleeGroups:append('MaxHaste')
				add_to_chat(3,'Max Haste Mode')

			else 
				classes.CustomMeleeGroups:append('HighHaste')
				add_to_chat(3,'High Haste Mode')
			end
		elseif buffactive[33] then
			if buffactive[604] or buffactive[228] or buffactive.march then
				classes.CustomMeleeGroups:append('MaxHaste')
				add_to_chat(3,'Max Haste Mode')
			else 
				classes.CustomMeleeGroups:append('HighHaste')
				add_to_chat(3,'High Haste Mode')
			end
		elseif buffactive[604] then
			if buffactive.march == 1 and buffactive[228] then
				classes.CustomMeleeGroups:append('MaxHaste')
				add_to_chat(3,'Max Haste Mode')
			elseif buffactive.march == 2 or buffactive[228] then
				classes.CustomMeleeGroups:append('MaxHaste')
				add_to_chat(3,'Max Haste Mode')
			elseif buffactive.march == 1 then
				classes.CustomMeleeGroups:append('HighHaste')
				add_to_chat(3,'High Haste Mode')
			else
				classes.CustomMeleeGroups:append('LowHaste')
			end
		elseif buffactive[228] then
			if buffactive.march then
				classes.CustomMeleeGroups:append('MaxHaste')
				add_to_chat(3,'Max Haste Mode')
			else
				classes.CustomMeleeGroups:append('HighHaste')
				add_to_chat(3,'High Haste Mode')
			end
		end
	elseif state.HasteMode.value == '1' then
		if buffactive[680] then 
			if buffactive[33] or buffactive[604] or buffactive[228] or buffactive.march then
				classes.CustomMeleeGroups:append('MaxHaste')
				add_to_chat(3,'Max Haste Mode')
			else 
				classes.CustomMeleeGroups:append('HighHaste')
				add_to_chat(3,'High Haste Mode')
			end
		elseif buffactive[33] then
			if buffactive[228] or buffactive.march == 2 then
				classes.CustomMeleeGroups:append('MaxHaste')
				add_to_chat(3,'Max Haste Mode')
			elseif buffactive[604] or buffactive.march == 1 then
				classes.CustomMeleeGroups:append('HighHaste')
				add_to_chat(3,'High Haste Mode')
			else 
				classes.CustomMeleeGroups:append('LowHaste')
				add_to_chat(3,'Low Haste Mode')
			end
		elseif buffactive[604] then
			if buffactive.march == 1 and buffactive[228] then
				classes.CustomMeleeGroups:append('MaxHaste')
				add_to_chat(3,'Max Haste Mode')
			elseif buffactive.march == 2 or buffactive[228] then
				classes.CustomMeleeGroups:append('MaxHaste')
				add_to_chat(3,'Max Haste Mode')
			elseif buffactive.march == 1 then
				classes.CustomMeleeGroups:append('HighHaste')
				add_to_chat(3,'High Haste Mode')
			else
				classes.CustomMeleeGroups:append('LowHaste')
				add_to_chat(3,'Low Haste Mode')
			end
		elseif buffactive[228] then
			if buffactive.march then
				classes.CustomMeleeGroups:append('MaxHaste')
				add_to_chat(3,'Max Haste Mode')
			else
				classes.CustomMeleeGroups:append('HighHaste')
				add_to_chat(3,'High Haste Mode')
			end
		end
	end
end




-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
	-- Default macro set/book
	if player.sub_job == 'DNC' then
		set_macro_page(4, 7)
	elseif player.sub_job == 'THF' then
		set_macro_page(5, 7)
	else
		set_macro_page(1, 7)
	end
end
