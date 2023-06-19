"""

"""



var names_array = [
    "Asher", "Luna", "Levi", "Stella", "Caleb", "Aurora", "Felix", "Willow",
    "Jasper", "Ruby", "Silas", "Ivy", "Milo", "Hazel", "Ezra", "Penelope",
    "Atticus", "Scarlett", "Sebastian", "Eleanor", "Emma", "Liam", "Olivia",
    "Noah", "Ava", "Sophia", "Isabella", "Mia", "Jackson", "Aiden", "Lucas",
    "Caden", "Harper", "Ethan", "Amelia", "Charlotte", "Benjamin", "Elijah",
    "William", "James", "Ethan", "Olivia", "Liam", "Sophia", "Benjamin", "Ava",
    "Samuel", "Isabella", "Daniel", "Mia", "Alexander", "Charlotte", "Noah", "Emma",
    "Gabriel", "Harper", "Matthew", "Amelia", "Jameson", "Lily", "Zephyr", "Lunaire",
    "Caspian", "Seraphina", "Magnus", "Aurora", "Orion", "Lyric", "Phoenix", "Juniper",
    "Atlas", "Calliope", "Maverick", "Celeste", "Orion", "Aria", "Remy", "Ophelia",
    "Finnegan", "Indira"]
    

func get_random_username():
    var s = names_array[randi() % names_array.size()]
    for i in 3:
        s += str(randi() % 9)
    return s
