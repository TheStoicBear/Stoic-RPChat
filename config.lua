config = {
    ["/me"] = true,
    ["/gme"] = true,
    ["/do"] = true,
    ["/twt"] = true,
    ["/ooc"] = true,
    ["/darkweb"] = {
        enabled = true,
        canNotSee = {
            "LSPD",
            "BCSO",
            "sasp",
            "LSFD"
        }
    },
    ["/radiochat"] = {
        enabled = true,
        canNotSee = {
            "CIV"
        }
    },
    ["/911"] = {
        enabled = true,
        callTo = {
            "LSPD",
            "BCSO",
            "sasp",
            "LSFD"
        }
    }
}