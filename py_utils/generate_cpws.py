import itertools
import json

def generate_cpws(trait_weightings):
    cpws = []

    for property in trait_weightings.values():
        cpw_lst = list(itertools.accumulate(property))[::-1]
        cpw = 0
        for trait in cpw_lst:
            cpw |= trait
            cpw <<= 8

        cpw |= len(property) - 1
        cpws.append(hex(cpw))

    return cpws

if __name__ == '__main__':
    with open('./py_utils/sample_bayc_traits.json', 'r') as file:
        # Assumes the trait IDs conforms to the outlined standards.
        trait_weightings = json.load(file)

    print(generate_cpws(trait_weightings))
