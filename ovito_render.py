from ovito.io import import_file
from ovito.vis import Viewport, TachyonRenderer
from ovito.modifiers import *

#Import file
pipeline = import_file('../dump.imp1000mps.38000')
pipeline.add_to_scene()

#Calculate adaptive CNA
modifier1 = CommonNeighborAnalysisModifier()
pipeline.modifiers.append(modifier1)

# Select atoms to delete
mod2=SelectExpressionModifier()
mod2.expression = '(Position.X < 980.0)||(Position.X > 1020.0)'
pipeline.modifiers.append(mod2)

#Delete selected atoms
mod3=DeleteSelectedParticlesModifier()
pipeline.modifiers.append(mod3)

#Assign radius to a particle type
types = pipeline.source.data.particles.particle_types
types.type_by_id(1).name = "substrate"
types.type_by_id(1).radius = 2.00
types.type_by_id(2).name = "particle"
types.type_by_id(2).radius = 2.00

#Image settings
vp = Viewport(type = Viewport.Type.Ortho, camera_dir = (1, 0, 0))
vp.zoom_all()
vp.render_image(filename='dump_38000.png', size=(1920, 1080), renderer=TachyonRenderer())
