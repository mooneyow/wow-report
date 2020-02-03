## Exploiting World of Warcraft
##### Date: 2016-11-2 22:05

World of Warcraft is a fun game that I like to play in my spare time. Because it's cool it supports user interface modifications through addons. These addons are written in lua and their functionality as you can imagine is pretty restricted to prevent scamming etc.

Addons are not allowed to communicate with the internet or process' outside of the game. They can however communicate with each other through "addon message channels". These channels are not seen by the player (unless explicitly printed by the addon).

One day my guild asked everyone to install the addon NKeystone. It allows guild members to see each others keystones. Keystones are an item in-game used to unlock timed dungeons for a chance at better loot. So, it was pretty handy to have.

Me being a programmer I thought wouldn't it be cool to send something back other than my keystone? A silly item perhaps? Thunderfury, Blessed Blade of the Windseeker was the obvious choice.

The addon works by sending a request to the player asking for their keystone. Their addon then sends the itemLink in reply.
```
function SendKeystoneInfo(target)
	local bagID, slotID = GetBagAndSlotIDForKeystone();
	local itemLink = GetItemLinkFromBagAndSlotID(bagID, slotID);
	if itemLink ~= nil then
		dist = target and "WHISPER" or "GUILD";
		SendAddonMessage(nkt.AddonPrefix, itemLink, dist, target);
	end
end
```
This seemed like an easy thing to do, lookup the itemLink and change the function a little. The problem being when I looked up item links at http://wowwiki.wikia.com/wiki/ItemLink they used the "|" divied as opposed to "\" which the game actually uses.

I attempted to print the item link to test that it was valid and bam, game immediately freezes up. No crash, but spamming the mouse results in Windows telling me that "World of Warcraft is not responding".

That's weird. I fixed the problem by replacing the itemLink with the correctly formatted version.

About ten minutes later I had a much better idea. Why not send the dodgy itemLink to other players on purpose and see if it will lock up their game client. What could go wrong? :P

NKeystone will just print messages it receives if they are correctly formatted, expecting itemLinks, what else could it be? 
This should do the trick:
```
SendAddonMessage(NKEYSTONE, "|124cffff8000|124Hitem:137225::::::::110:::::|124h[Thunderfury, Blessed Blade of the Windseeker]|124h|124r", "WHISPER", targetName);
```
(Addon messages can be to various different channels like your guild or the current raid group. Whisper sends it to one specific player.)

I had a helpful friend of mine install the addon to test it. And of course it worked and locked up his game.

Now at this point I could have stopped. I've found a way to crash a print function in the game and I can make other players addons call the function with my dodgy string. But meh, lets find more.

https://mods.curse.com/addons/wow/rclootcouncil was my next attempt. It has 500k+ monthly downloads and sends a lot of addon messages.

Because addons in the game cannot communicate with the internet it is difficult to tell when they are out of date. They accomplish this by instead sending other players their version numbers. When a version number is received that is higher than the one installed they prompt the user to update...by printing to their chat.
Like this:

![screenshot](https://raw.githubusercontent.com/mooneyow/wow-report/master/WoWScrnShot_110216_203126.jpg)

Bingo. We now have a delivery mechanism common to many addons.

With some magic CTRL+F the version sending function of RCLootCouncil is found and a delivery method written:
```
addon:SendCommand(targetName, "verTest", "|124cffff8000|124Hitem:19019::::::::::0\124h[Did Someone Say?]\124h\124r", self.playerName);
```
Their game locks up instantly, nothing is printed, they don't know what caused it. And because the game does not propery crash I don't believe that it logs it (I could be totally wrong here but I couldn't find crash logs where they normally go).

It also happens to be used by all the hardcore progress raiders and most Twitch streamers. Fun could be had, but I'm a responsible adult. 

There's two addons, lets try more. How about the most popular addon in the game with 5 million monthly downloads https://mods.curse.com/addons/wow/deadly-boss-mods?

Now, this addon checks what channel the addon message was sent to, most of the time.
Version numbers are only printed if received by two group members. Oh well.
If in a group you can also send an invalid note and it will print an error to chat. I can't get anyone, but hey, I can still crash some people.

So I couldn't find a way to get it to print messages from random players, I did however find a way to send anyone a countdown that pops up on their screen and verbally counts down like this: https://youtu.be/bQs_-drb6z0?t=26
That's something I guess. There was some other trickery you could do as well but it was patched after I notified the developer.

I tried getting some other addons but most of them very sensibly cast version numbers to numbers.
There are definately more that print error messages with strings from other players, but I'm in college and do not have time to read tons of code in a language I don't write...

Blizzard don't have a bug bounty program so it's a little difficult to get in-touch. Here's the timeline of how it went:

**2016-10-7** Submitted report to Blizzard via customer support

**2016-10-7** Warned NKeystone developer (I thought the bug was specific to this addon at this point, I handn't really thought about try others)

**2016-10-8** Received reply frm customer support, I was much too vague

**2016-10-8** Re-submitted report with much more detail

**2016-10-9** Was asked to submit to a different email for hacking reports and exploits in general. They don't reply to things submitted here unfortunately.

**2016-10-9** Submit to this different email

**2016-10-9** Receive reply from NKeystone developer, they patch NKeystone to validate itemLinks making it invulnerable to the crash. They also work at Blizzard and very kindly passed it on to the right people.

**2016-10-11** Received confirmation that the WoW team is working on the bug.

**2016-10-25** Bug is fixed in game client with patch 7.1!
