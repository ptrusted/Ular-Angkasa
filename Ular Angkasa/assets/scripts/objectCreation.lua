
function createGameObject(active, name, image, positionX, positionY, rotation, scaleX, scaleY, offsetX, offsetY, animation, animator, behaviour, index)
    local temporaryObject = {}
    temporaryObject.active = active
    temporaryObject.name = name
    temporaryObject.image = image
    temporaryObject.positionX = positionX
    temporaryObject.positionY = positionY
    temporaryObject.rotation = rotation
    temporaryObject.scaleX = scaleX
    temporaryObject.scaleY = scaleY
    temporaryObject.offsetX = offsetX or 0
    temporaryObject.offsetY = offsetY or 0
    temporaryObject.animation = animation
    temporaryObject.animator = animator
    temporaryObject.behaviour = behaviour
    temporaryObject.index = index

    return temporaryObject
end