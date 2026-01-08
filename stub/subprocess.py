if sys.platform == "horizon":
    from stub.subprocess import *
    raise ImportError
