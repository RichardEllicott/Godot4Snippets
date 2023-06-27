"""
clear all children of a node, you don't have to use queue_free and indeed, queue_free will not clear the children in time incase you create and iterate new ones in the same frame
  
"""


static func clear_children(_self: Node):
  for child in _self.get_children():
      _self.remove_child(child)
#        child.queue_free() # this would ensure it is definatly deleted even if referenced elsewhere
