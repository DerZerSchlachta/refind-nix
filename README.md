# NixOS rEFInd module
This is a NixOS module to install and configure the rEFInd bootloader completely from nixOS including themes.

## options
<table>
    <div>
        <tr>
            <td colspan="2"><b>boot.loader.refind.enable</td>
        </tr>
        <tr>
            <td>Type</td>
            <td>types.bool</td>
        </tr>
        <tr>
            <td>Default</td>
            <td>false</td>
        </tr>
        <tr>
            <td>Description</td>
            <td>Whether to enable the refind EFI boot manager</td>
        </tr>
    </div>
    <div>
        <tr>
            <td colspan="2"><b>boot.loader.refind.maxGenerations</td>
        </tr>
        <tr>
            <td>Type</td>
            <td>types.int</td>
        </tr>
        <tr>
            <td>Default</td>
            <td>100</td>
        </tr>
        <tr>
            <td>Description</td>
            <td>Maximum number of generations in submenu. This is to avoid problems with refind or possible size problems with the config</td>
        </tr>
    </div>
    <div>
        <tr>
            <td colspan="2"><b>boot.loader.refind.extraIcons</td>
        </tr>
        <tr>
            <td>Type</td>
            <td>types.nullOr types.path;</td>
        </tr>
        <tr>
            <td>Defalt</td>
            <td>100</td>
        </tr>
        <tr>
            <td>Description</td>
            <td>A directory containing icons to be copied to 'extra-icons'</td>
        </tr>
    </div>
    <div>
        <tr>
            <td colspan="2"><b>boot.loader.refind.themes</td>
        </tr>
        <tr>
            <td>Type</td>
            <td>types.listOf types.path;</td>
        </tr>
        <tr>
            <td>Defalt</td>
            <td>[]</td>
        </tr>
        <tr>
            <td>Description</td>
            <td>A list of theme paths to copy</td>
        </tr>
    </div>
    <div>
        <tr>
            <td colspan="2"><b>boot.loader.refind.extraConfig</td>
        </tr>
        <tr>
            <td>Type</td>
            <td>types.lines</td>
        </tr>
        <tr>
            <td>Defalt</td>
            <td>""</td>
        </tr>
        <tr>
            <td>Description</td>
            <td>Extra configuration text appended to refind.conf</td>
        </tr>
    </div>

</table>



## Example Configuration
```nix
{
    boot.loader = {
        efi = {
            efiSysMountPoint = "/boot/efi";
            canTouchEfiVariables = true;
        };
        refind = {
            enable = true;
            maxGenerations = 10;
        };
    };
}
```
`boot.loader.efi.canTouchEfiVariables` must be enabled for refind to install correctly with `boot.loader.efi.efiSysMountPoint` correctly pointing to the esp mount point.

## Credits
[betaboon](https://github.com/betaboon) made the original nixos-module for rEFInd on his [gist](https://gist.github.com/betaboon/97abed457de8be43f89e7ca49d33d58d) which is the base for this module. Most of this codebase is his code but updated to work on latest nixpkgs-unstable
