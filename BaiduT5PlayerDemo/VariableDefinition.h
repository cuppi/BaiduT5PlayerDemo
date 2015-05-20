//
//  VariableDefinition.h
//  AssistantOfLOL
//
//  Created by AC_cuppi on 11/8/14.
//  Copyright (c) 2014 CPZero-Cuppi. All rights reserved.
//

#ifndef AssistantOfLOL_VariableDefinition_h
#define AssistantOfLOL_VariableDefinition_h

#define __kDScreenWidth [UIScreen mainScreen].bounds.size.width
#define __kDScreenHeight [UIScreen mainScreen].bounds.size.height

#define CGFLOAT_ANY 0
#define CGFLOAT_ANY_NOZERO 1
#define CGRect_WidthHeight(__rect__,width,height) CGRectMake((__rect__).origin.x, (__rect__).origin.y,  width, height)
#define CGRect_Width(__rect__,width) CGRectMake((__rect__).origin.x, (__rect__).origin.y, width, (__rect__).size.height)
#define CGRect_Height(__rect__,height) CGRectMake((__rect__).origin.x, (__rect__).origin.y,  (__rect__).size.width, height)

#define CGRect_OriginXY(__rect__, originX, originY) CGRectMake(originX, originY,CGWidth(__rect__), CGHeight(__rect__))
#define CGRect_OriginX(__rect__,x) CGRectMake((x), (__rect__).origin.y, (__rect__).size.width, (__rect__).size.height)
#define CGRect_OriginY(__rect__,y) CGRectMake((__rect__).origin.x, (y), (__rect__).size.width, (__rect__).size.height)

#define CGRectMake_Height(height)  CGRectMake(CGFLOAT_ANY, CGFLOAT_ANY, CGFLOAT_ANY, height)
#define CGRectMake_Width(width)  CGRectMake(CGFLOAT_ANY, CGFLOAT_ANY,width, CGFLOAT_ANY)
#define CGRect_AbsoluteBottom(__rect__)  (__rect__).origin.y + (__rect__).size.height
#define CGRect_AbsoluteRight(__rect__)  (__rect__).origin.x + (__rect__).size.width

#define CGWidth(__rect__) (__rect__).size.width
#define CGHeight(__rect__) (__rect__).size.height
#define CGOriginX(__rect__) (__rect__).origin.x
#define CGOriginY(__rect__) (__rect__).origin.y


#define __kSimpleResizeOfImage(__string__) [[UIImage imageNamed:__string__]resizableImageWithCapInsets:UIEdgeInsetsMake(1, 1, 1, 1) resizingMode:UIImageResizingModeStretch]

#endif
