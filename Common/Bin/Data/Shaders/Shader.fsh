//
//  Shader.fsh
//  zMesh
//
//  Created by Mathieu Ledru on 14/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

varying lowp vec4 colorVarying;

void main()
{
    gl_FragColor = colorVarying;
}
