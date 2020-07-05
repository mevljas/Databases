import pyodbc


def gostota(imeAlianse):
    cnxn = pyodbc.connect('DSN=DOMA;UID=pb;PWD=pbvaje')
    cursor = cnxn.cursor()
    inserter = cnxn.cursor()
    inserter.execute("DROP TABLE IF EXISTS gostota_Populacije")
    inserter.execute("DROP TABLE IF EXISTS gostota_Alianse")
    cnxn.commit()

    inserter.execute("CREATE TABLE gostota_Populacije ("
                     "id INTEGER PRIMARY KEY AUTO_INCREMENT, "
                     "x INTEGER, y INTEGER,"
                     "gostota DOUBLE) "
                     "DEFAULT CHARSET=utf8 COLLATE=utf8_slovenian_ci;")
    inserter.execute("CREATE TABLE gostota_Alianse ("
                     " id INTEGER PRIMARY KEY AUTO_INCREMENT, "
                     "x INTEGER, "
                     "y INTEGER, aliansa VARCHAR(100), "
                     "gostota DOUBLE )"
                     "DEFAULT CHARSET=utf8 COLLATE=utf8_slovenian_ci;")
    cnxn.commit()
    gostotaPopulacije = {}
    xpos = []
    ypos = []
    dz = []

    for x in range(-250, 241, 10):
        for y in range(-250, 241, 10):
            cursor.execute("SELECT COALESCE(SUM(population), 0) AS p "
                           "FROM naselje "
                           "WHERE (x BETWEEN ? AND ?) AND (y BETWEEN ? AND ?)", x, x + 9, y, y + 9)
            gostotaPopulacije[(x, y)] = cursor.fetchone().p / 100
            xpos.append(x)
            ypos.append(y)
            dz.append(gostotaPopulacije[(x, y)])
            inserter.execute("INSERT INTO gostota_Populacije(x, y, gostota) "
                             "VALUES( ?,?,?)", x, y,
                             gostotaPopulacije[(x, y)])
    cnxn.commit()

    gostotaAlianse = {}
    for x in range(-250, 241, 10):
        for y in range(-250, 241, 10):
            cursor.execute("SELECT COALESCE(SUM(n.population), 0) AS p "
                           "FROM naselje n "
                           "INNER JOIN igralec i USING(pid) "
                           "INNER JOIN aliansa a USING(aid) "
                           "WHERE (n.x BETWEEN ? AND ?) AND (n.y BETWEEN ? AND ?) AND a.alliance=? ", x, x + 9, y,
                           y + 9, imeAlianse)
            gostotaPopulacije[(x, y, imeAlianse)] = cursor.fetchone().p / 100
            inserter.execute("INSERT INTO gostota_Alianse(x, y, aliansa, gostota) "
                             "VALUES( ?,?,?,?)", x, y, imeAlianse,
                             gostotaPopulacije[(x, y, imeAlianse)])

    cnxn.commit()
    cnxn.close()

    import matplotlib.pyplot as plt
    import mpl_toolkits.mplot3d.axes3d as p3

    fig = plt.figure()
    fig.set_size_inches(12, 8, forward=True)
    ax = p3.Axes3D(fig)

    bars = []
    for i in range(len(xpos)):
        bars.append(ax.bar3d(xpos[i], ypos[i], 0, 10, 10, dz[i], color="#00BFFF"))
    ax.set_title('Gostota populacije')
    ax.xaxis.set_label_text("X")
    ax.yaxis.set_label_text("Y")
    ax.zaxis.set_label_text("Gostota")
    ax.set_xticks([-200 , -150, -100, -50, 0, 50, 100, 150, 200])
    ax.set_yticks([-200 , -150, -100, -50, 0, 50, 100, 150, 200])

    plt.show()


gostota("RS-SN")

