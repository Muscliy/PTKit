//
//  XMColorMacro.h
//  Drummer
//
//  Created by leehu on 14-3-6.
//  Copyright (c) 2014年 Lee Hu. All rights reserved.
//

#ifndef PTKit_PTColorMacro_h
#define PTKit_PTColorMacro_h

#define CREATE_RGBA_COLOR(r, g, b, a)                                                              \
    [UIColor colorWithRed:r / 255.0 green:g / 255.0 blue:b / 255.0 alpha:a]

#define XRGBA CREATE_RGBA_COLOR

#define COLOR_78_152_73		CREATE_RGBA_COLOR(78, 152, 73, 1)
#define COLOR_80_148_75		CREATE_RGBA_COLOR(80, 148, 75, 1)
#define COLOR_80_80_80		CREATE_RGBA_COLOR(80, 80, 80, 1)
#define COLOR_216_216_216	CREATE_RGBA_COLOR(216, 216, 216, 1)
#define COLOR_202_202_202	CREATE_RGBA_COLOR(202, 202, 202, 1)
#define COLOR_255_86_1		CREATE_RGBA_COLOR(255, 86, 1, 1)
#define COLOR_218_222_221	CREATE_RGBA_COLOR(218, 222, 221, 1)
#define COLOR_223_227_226	CREATE_RGBA_COLOR(223, 227, 226, 1)
#define COLOR_251_250_248	CREATE_RGBA_COLOR(251, 250, 248, 1)
#define COLOR_199_201_200	CREATE_RGBA_COLOR(199, 201, 200, 1)
#define COLOR_99_172_91		CREATE_RGBA_COLOR(99, 172, 91, 1)
#define COLOR_132_132_132	CREATE_RGBA_COLOR(132, 132, 132, 1)
#define COLOR_58_136_159	CREATE_RGBA_COLOR(58, 136, 159, 1)
#define COLOR_159_159_159	CREATE_RGBA_COLOR(159, 159, 159, 1)
#define COLOR_84_160_77		CREATE_RGBA_COLOR(84, 160, 77, 0.1)

#define COLOR_TITLEBAR_GREEN	COLOR_99_172_91                      // titlebar绿色
#define COLOR_EMPHASIS			COLOR_80_148_75                            //强调色
#define COLOR_MAIN_TEXT			COLOR_80_80_80                            //正文色
#define COLOR_SUBTEXT			COLOR_132_132_132                           //辅助文本色
#define COLOR_WARNING			COLOR_255_86_1                              //警示色
#define COLOR_SEPARATOR			COLOR_218_222_221                         //页面间隔线色
#define COLOR_TABBAR_SEPARATOR	COLOR_223_227_226                  // tabbar间隔色
#define COLOR_SHADE				COLOR_251_250_248                             //底纹色
#define COLOR_NOTE_TEXT			COLOR_199_201_200                         //注释文本色
#define COLOR_TITLEBAR_WHITE	CREATE_RGBA_COLOR(255, 255, 255, 1)  // titleBar白色
#define COLOR_CELL_HIGHTLIGHT	CREATE_RGBA_COLOR(36, 103, 29, 0.8) //全局列表选中色
#define COLOR_IMAGE_HIGHTLIGHT	CREATE_RGBA_COLOR(3, 37, 0, 0.7)   //全局图片选中色
#define COLOR_ADVBANNER_BG		CREATE_RGBA_COLOR(252, 252, 252, 1)    //广告banner填充色
#define COLOR_CURSOR			CREATE_RGBA_COLOR(175, 184, 171, 1)

#endif
