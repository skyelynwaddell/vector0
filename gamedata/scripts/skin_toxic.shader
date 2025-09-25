9mm_toxic
{
    // Draw Default Texture for model
    diffusemap textures/pistol.png 

    // Default Shader for shadows
    {  
        program defaultskin
    }
    // Brighten default texture
    {
        map textures/pistol.png
        blendFunc GL_ONE GL_ONE_MINUS_SRC_ALPHA  
        rgbGen identity
        alphaGen const 0.1
    }
    // Brighten default texture
    {
        map textures/pistol.png
        blendFunc GL_ONE GL_ONE_MINUS_SRC_ALPHA
        rgbGen identity
        alphaGen const 0.1
    }
    // Draw the overlayed SKIN texture
    {   
        map textures/water_blue.png
        blendfunc GL_DST_COLOR GL_ZERO
    }
}