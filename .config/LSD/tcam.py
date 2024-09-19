import sys
import inspect


def encode1(img_path, text, save_name="encode", delimiter: str = "11111110"):
    print(inspect.currentframe().f_locals)  # type: ignore
    print(f"Execution of {inspect.currentframe().f_code.co_name} -  OK")  # type: ignore
    return None


def encode2(img_path, text, save_name="encode", delimiter: str = "11111110"):
    print(inspect.currentframe().f_locals)  # type: ignore
    print(f"Execution of {inspect.currentframe().f_code.co_name} -  OK")  # type: ignore
    return None


def decode(img_path, file_path: str = str(), delimiter: str = "11111110"):
    print(inspect.currentframe().f_locals)  # type: ignore
    print(f"Execution of {inspect.currentframe().f_code.co_name} -  OK")  # type: ignore
    return None


def ff(_) -> None:
    print("Decorator function Exicuted.")
    return None


struc = {
    "-e": {
        "alias": ["--encode"],
        "input": True,
        "input_type": {
            "datatype": str,
            "description": "path-to-image",
            "parameter": "img_path",
        },
        "output": True,
        "function": encode1,
        "decorator_function": ff,
        "default_args": {
            "delimiter": "11111110",
        },
        "next": {
            "-m": {
                "alias": ["--message"],
                "input": True,
                "input_type": {
                    "datatype": str,
                    "description": "message-to-encode",
                    "parameter": "text",
                },
                "output": True,
                "function": encode2,
                "next": None,
            },
            "-f": {
                "alias": ["--file"],
                "input": True,
                "input_type": {
                    "datatype": str,
                    "description": "path-to-file",
                    "parameter": "file_path",
                },
                "output": True,
                "function": encode2,
                "next": None,
            },
        },
    },
    "-d": {
        "alias": ["--decode"],
        "input": True,
        "input_type": {
            "datatype": str,
            "description": "path-to-image",
            "parameter": "img_path",
        },
        "output": True,
        "function": decode,
        "decorator_function": ff,
        "next": {
            "-o": {
                "alias": ["--output"],
                "optional": False,
                "input": True,
                "input_type": {
                    "datatype": str,
                    "description": "output-file-name",
                    "parameter": "file_path",
                },
                "output": True,
                "next": None,
            }
        },
    },
    "-h": {
        "alias": ["--help"],
        "input": False,
        "output": True,
        "function": help,
        "next": None,
    },
}


class Tcam:
    """
    It is a class for Handling the Terminal command flags.
    """

    def __init__(self, structure) -> None:
        """
        Constricter takes 1 arg:
            <structure>  :  It defines the structer of the Terminal command workflow.
                            Note:- only enter value if want of modify it. The values
                            in the EX are the default values.
                Ex:-
                    {
                        "<-some_flag>" : {
                            "alias" : [<str>] | None,
                            "input" : <True | False>,
                            "input_type":{              # If input is True.
                                "datatype" : <datatype-instance>,
                                "description": <description-of-input>,
                                "parameter": <by-which-parameter-function-will-this-input>,
                            },
                            "output" : <True | False>,
                            "function" : <function-reference>} | None,
                            "decorator_function": <function-instance-which-will-be-wrapped-around-"function">,
                            "next": {<next-flag-with-same-structure>} | None,
                        }
                    }
        """
        self.structure: dict = structure
        self.args = sys.argv[1:]

    def run(self):
        """
        It runs the Terminal command and parces all the
        args and puts them all in the function.
        """
        config = self.__run_config()
        print(config)
        if config.get("decorator_function"):
            config["decorator_function"](config["function"](**config["input_dict"]))
        else:
            config["function"](**config["input_dict"])

    def __run_config(self):
        """
        Config for self.run function.
        """
        config_dict = {
            "input_dict": {},
            "default_args": {},
            "function": None,
            "decorator_function": None,
        }
        all_alias = self.alias()
        current_flag = self.structure.copy()
        arg_index = 0
        current_arg = None
        while True:
            current_arg = self.args[arg_index]
            if current_arg in current_flag:
                current_flag = current_flag[current_arg]
            elif current_arg in all_alias:
                current_arg = all_alias[current_arg]
                current_flag = current_flag[all_alias[current_arg]]
            else:
                raise ValueError(
                    "The commands goes like:-\n"
                    + "\n".join([value for value in self.commands() if self.args]),
                )
            if current_flag.get("input") is True:
                arg_index += 1
                config_dict["input_dict"][current_flag["input_type"]["parameter"]] = (
                    self.args[arg_index]
                )
            if current_flag.get("default_args"):
                config_dict["default_args"].update(current_flag["default_args"])
            if current_flag.get("function"):
                config_dict["function"] = current_flag["function"]
            if current_flag.get("decorator_function"):
                config_dict["decorator_function"] = current_flag["decorator_function"]
            if current_flag.get("next"):
                current_flag = current_flag["next"]
            else:
                break
            arg_index += 1
        return config_dict

    def alias(self):
        """
        It return all the alias in a dict formate.
            Ex:- { <alias>:<flag> }
        """
        return {
            value: key
            for key, values in self.structure.items()
            if values.get("alias")
            for value in values.get("alias")
        }

    def commands(self, struc: dict | None = None):
        """
        It return all the command combination of the structure.
        """
        if struc is None:
            struc = self.structure
        result = []
        i_key = ""
        for key in struc.keys():
            i_key = key
            if struc[key].get("alias"):
                og_key = key.split(" ")
                old_key = og_key[:-1]
                og_key = og_key[-1]
                i_key = (
                    " ".join(old_key)
                    + " <"
                    + " | ".join([og_key] + struc[key]["alias"])
                    + ">"
                )
            if struc[key].get("input") is True:
                if input_type := struc[key].get("input_type"):
                    if input_type.get("description"):
                        i_key += f" <{input_type['description']}> "
                    else:
                        i_key += " <input> "
                else:
                    i_key += " <input> "
            if nx := struc[key].get("next"):
                for next_key in nx.keys():
                    result.append(
                        *self.commands(struc={i_key + next_key: nx[next_key]})
                    )
            else:
                result.append(i_key)
        return result

    def __str__(self) -> str:
        return str(self.__repr__)

    def __add__(self, other):
        f"""
        Addes the instance.structure and return new Tcam class
        with current.structure + instance.structure.
        """
        if isinstance(other, Tcam):
            return Tcam(self.structure.update(self.other.structure))  # type: ignore
        else:
            return TypeError(f"Only supports the type of " + Tcam.__name__)

    def __repr__(self) -> str:
        return f"{Tcam.__name__}({self.structure})"


x = Tcam(struc)

# path = x.commands()
# print(*path, sep="\n")

# help(Tcam)
x.run()
