"""
these unicode symbols look good in the Godot font and work well with Label3D

https://symbl.cc/en/search/?q=Heart+symbols
https://www.unicode.org/emoji/charts/full-emoji-list.html

notable exceptions in Godot so far is the
gold coin: 🪙

also some look better in Godot
shield: 🛡

https://symbl.scc/en/search/?q=Heart+symbols
https://www.unicode.org/emoji/charts/full-emoji-list.html


seems to find related:
    https://emojiterra.com/spider-web/

"""
@tool
extends Node


func _ready():
    pass

func macro_update_label():
    $Label3D.text = symbols
    
func macro_iterating_chars_with_unicode_is_bad():
    var s = "👨‍✈️👩‍✈️👨‍🚀👩‍🚀" # 4 chars
    for char in s: # becomes different chars
        print(char)
    
func macro_test():
    
    var s = ""
    
    var count = 0
    
    var dict = {}
    for char in symbols:
        dict[char] = null
    
    var i = 0
    for key in dict:
        i += 1
        s += key
        if i % 10 == 0:
            s += "\n"
    $Label3D.text = s
    print(s)

var symbols = """

🔫🚀💣💥⚡❤️🗝️💊💉☠️🔥🛡💲💯☢🧨
👑💰💍💎🏆🎁
🥇🥈🥉
✨🎆🎇
🎂🍰🍦

💬💤💭✉️🌍🌐🚬🍷🌼🛸🪐☀️☎️

💩🤡👽🤖👹👺👶🧒👦👧🧑👱👨🧔👨‍🦰👨‍🦱👨‍🦳👨‍🦲👩👩‍🦰👩‍🦱👩‍🦳👩‍🦲👱‍♀️👱‍♂️🧓👴👵🤴👸👳👳‍♀️👲
👼🎅🤶🐵🐶🦊🦝🐱😺🦁🐯🐷🐗🐹🐻🐨🐼🐸

🎰
🍒🍓🍋🍊💎🍇🔔🍉7
🍌🍏🍊🍹
🍎🍏
🥝🍔
🧪🦠💀
♠️♥️️♣♦️♡
⭐
💔💙💛💚💜🖤🤍
🔑🚪
☘️🌈🌷
🦇🌙🌕🦉🕷️🧛‍♂️🕸️🎃👻⚰️🩸
🥚🐣🐥🐤🐓
🍗
🦘🦎🧝🧙🐲🐔🐣🐭
🌟🌠🌈☣
💀👻👾💫🧸

👨‍⚕️👩‍⚕️👨‍🎓👩‍🎓👨‍🏫👩‍🏫👨‍⚖️👩‍⚖️
👨‍🌾👩‍🌾👨‍🍳👩‍🍳👨‍🔧👩‍🔧👨‍🏭👩‍🏭👨‍💼👩‍💼👨‍🔬👩‍🔬👨‍🎤👩‍🎤👨‍🎨👩‍🎨👨‍✈️👩‍✈️👨‍🚀👩‍🚀
"""


