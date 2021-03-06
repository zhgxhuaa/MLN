/**
  * Created by MomoLuaNative.
  * Copyright (c) 2019, Momo Group. All rights reserved.
  *
  * This source code is licensed under the MIT.
  * For the full copyright and license information,please view the LICENSE file in the root directory of this source tree.
  */
package com.immomo.mls.adapter;

/**
 * Created by Xiong.Fangyu on 2018/11/13
 */
public interface ScriptReaderCreator {

    ScriptReader newScriptLoader(String src);
}