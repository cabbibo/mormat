using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class BindBrainPosition : Binder
{
  public Hydra hydra;
  public override void Bind(){
    toBind.BindVector3( "_BrainPosition" , () => hydra.brain.position );
  }
}
