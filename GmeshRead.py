import numpy as np

class mesh2d:
    def __init__(self, filename):
        self.filename = filename
        self.A = []
        self.nodes = []
        self.Nnodes = 0
        self.Nel = 0
        self.T = None
        self.coords = {}
        self.arrets = None
        self.connect = {}
        self.connectoo = {}
        self.connect_val = {}
        self.neudes_bord = []
        self.label = {}
        self.diam = None
        self.aire = None
        self.total= 0
        self.points_lists  = [[], [], [], []]
        self.coords_lists = []

    def lire_fichier(self):
        with open(self.filename, 'r') as f:
            self.lines = f.readlines()
            found_elements = False
            for line in self.lines:
                if found_elements:
                    self.total = int(line)
                    break
                if "$Elements" in line:
                    found_elements = True

    def detect_element(self):
        for line in self.lines:
            data = line.split()
            if len(data) > 7 and data[1] == '2':
                self.Nel += 1
                self.A.append(int(data[0]))
                self.nodes.append(list(map(int, data[5:8])))
        self.nodes = np.array(self.nodes)
        self.A = np.array(self.A)
        self.T = np.zeros((self.Nel, 3), dtype=int)

    def detect_neudes(self):
        for line in self.lines:
            data = line.split()
            if len(data) == 4:
                self.Nnodes += 1
                node_id = int(data[0])
                self.coords[node_id] = tuple(map(float, data[1:3]))

    def detect_arret(self):
        for i in range(self.Nel):
            for j in range(3):
                self.T[i, j] = self.nodes[i,j]
        self.arrets = np.zeros((len(self.T) * 3, 2), dtype=int)
        for i, triangle in enumerate(self.T):
            for j in range(3):
                node1, node2 = (triangle[j], triangle[(j+1)%3])
                self.arrets[i * 3 + j, 0] = node1
                self.arrets[i * 3 + j, 1] = node2

    def connectivite(self):
        for i in range(self.Nel):
            for j in range(3):
                #node = self.arrets[i * 3 + j, 0]
                node = self.arrets[i * 3 + j, 0]
                u = self.total - self.Nel
                value = self.T[i, j]
                self.connect[(self.A[i] - (u+1), j)] = value
    def connecto(self):
        for i in range(self.Nel):
            for j in range(3):
                node = self.arrets[i * 3 + j, 0]
                self.connectoo[(self.A[i], node)] = self.coords[self.T[i, j]]
    def connect_val_dict(self):
        for i in range(self.Nel):
            for j in range(3):
                node = self.arrets[i * 3 + j, 0]
                u = self.total - self.Nel
                self.connect_val[(self.A[i] - (u+1), j)] = self.coords[self.T[i, j]]

    def point_bord(self):
        for line in self.lines:
            data = line.split()
            if len(data) > 4 and data[1] == '1':
                self.neudes_bord.extend(list(map(int, data[5:7])))
        self.neudes_bord = list(set(self.neudes_bord))
    def border_liness(self):
          # List of lists to hold points
        add_points = [False, False, False, False]  # Flags for each list
        for line in self.lines:
            data = line.split()
            if len(data) > 4 and data[1] == '1':
                if data[6] == '5' :
                    add_points = [True, False, False, False]
                elif data[5] == '2':
                    add_points = [False, True, False, False]
                elif data[5] == '3':
                    add_points = [False, False, True, False]
                elif data[5] == '4':
                    add_points = [False, False, False, True]
                #elif data[6] == '1':
                    #add_points = [False, False, False, False]
                for i in range(4):
                    if add_points[i]:
                        last_point = int(data[-1])
                        last_last = int(data[-2])
                        if last_last not in self.points_lists[i]:
                            self.points_lists[i].append(last_last)
                        if  last_point not in self.points_lists[i]:
                            self.points_lists[i].append(last_point)
        return self.points_lists
    def border_lines_coords_(self, points_lists):
        for points in points_lists:
            coords = []
            for point in points:
                coords.append(self.coords[point])
            self.coords_lists.append(coords)
        return self.coords_lists


    def label_info(self):
        for (element, node), coords in self.connect.items():
            self.label[(element, node)] = ('border' if node in self.neudes_bord else 'internal',coords)
    def calcule_de_diam(self):
        self.diam = np.zeros(self.Nel)
        for i in range(self.Nel):
            diameters = []
            for j in range(3):
                node1 = self.arrets[i * 3 + j, 0]
                node2 = self.arrets[i * 3 + j, 1]
                diameters.append(np.linalg.norm(np.array(self.coords[node1]) - np.array(self.coords[node2])))
            self.diam[i] = max(diameters)
        self.h = max(self.diam)
    def calcul_aire(self):
        self.aire = np.zeros(self.Nel)
        for i in range(self.Nel):
            x1, y1 = self.coords[self.nodes[i, 0]]
            x2, y2 = self.coords[self.nodes[i, 1]]
            x3, y3 = self.coords[self.nodes[i, 2]]
            self.aire[i] = 0.5 * abs((x1*(y2-y3) + x2*(y3-y1) + x3*(y1-y2)))

    def process(self):
        self.lire_fichier()
        self.detect_element()
        self.detect_neudes()
        self.detect_arret()
        self.connectivite()
        self.connecto()
        self.connect_val_dict()
        self.point_bord()
        self.label_info()
        self.calcule_de_diam()
        self.calcul_aire()
        points_lists = self.border_liness()
        self.border_lines_coords_(points_lists)
    def print_info(self):
        print("Nombre des neudes:", self.Nnodes)
        print("Nombre des elements:", self.Nel)
        print("les coordonnées des points:", self.coords)
        print("Les coordonnées des points de bord:", self.neudes_bord)
        print("label pour les information sur les points ", self.label)
        print("Tableux de connectivité :", self.connect)
        print("tableaux de connectivité :", self.connectoo)
        print("les points de chaque elements",self.connect_val)
        print("Diamètre de chaque élément:", self.diam)
        print("Aire de chaque élément:", self.aire)
        print(" le nombre total ",self.total)
        print("le pas de maillage ",self.h)
        print('les arrets de bord:',self.points_lists)
        print('les arrets de bord:',self.coords_lists)
        print('detect cells',self.nodes)
   
    
    
    
    

# Utilisation de la classe
if __name__ == '__main__':
    mesh = mesh2d("./maillage/cercle.msh")
    mesh.process()
    #mesh.compute_all_transformation_matrices()
    # Afficher les aires de tous les éléments
    mesh.print_info()
