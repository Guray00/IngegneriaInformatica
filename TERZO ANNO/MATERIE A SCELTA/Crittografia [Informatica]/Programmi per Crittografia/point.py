class point:
    def __init__(self, x = 'O', y = 'O'):
        self.x = x
        self.y = y

    def is_punto_infinito(self):
        return (str(self)) == 'O'

    def __str__(self):
        if self.x == 'O' and self.y == 'O': return f'O'
        else: return f'({self.x}, {self.y})'