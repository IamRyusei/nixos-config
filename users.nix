# File: /etc/nixos/users.nix
# Description: This file contains the declarative configuration for users and groups.

{ config, lib, pkgs, ... }: 
{
  users = {
    mutableUsers = false;
    enforceIdUniqueness = true;
    allowNoPasswordLogin = false;
#    defaultUserHome = "/home";
#    defaultUserShell = pkgs.bash;
    
    groups = {
      # todo
    };
    
    users = {
      "root" = {
        uid = 0;
        group = "root";
        hashedPassword = "$6$1jyu6h3.Aui/WBIn$Xv5OORdaM5mXzoSIhLzhh9t1Ev1tx5AhtobTqPRvf1/y3Av47rmznLzCl66CH/6YnZZ.KMpZI.kto7a.LtjOm.";
      };
      "leonard0" = {
        uid = 1000;
        isNormalUser = true;
        description = "Leonardo Spaccini";
        hashedPassword = "$6$1jyu6h3.Aui/WBIn$Xv5OORdaM5mXzoSIhLzhh9t1Ev1tx5AhtobTqPRvf1/y3Av47rmznLzCl66CH/6YnZZ.KMpZI.kto7a.LtjOm.";
        extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
      };
    };

  };
}
